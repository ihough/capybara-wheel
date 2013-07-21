# Capybara::Wheel
> Keeping the rodent on track

Capybara wheel is a page model framework which natively and (hopefully) easily enforces stability coventions:

- No memoization. Every action or query relating to the page should make a new find callback to the actual page.
 - Enforces native Capybara wait time when interacting with the page if the element is not there (yet) or changed.

- No access to capybara directly from the specs.
  - Enforces single point of reference to selectors / elements.
  - Also helps reducing memoizations.

- Element hierarchy structure to scope finds to a specific section of the page.
  - Reduces ambiguity.

*A special thank you to @woollyams for the initial concept*

## Why Wheel?

Browser driven acceptance tests are notorious for being unstable and hard to maintain. The main culprits are:

1. Timing issues which result in unstable waits and "is the page loaded?" queries accross the specs.

2. Memoizing the state of the page (e.g. `search_result = Capybara.find('li')` ) at a certain time. Each spec run might memoize a different state, leading to unstable tests.

3. No convention around page interactions (e.g. sometimes calling a page model, sometimes a native find with a selector).

Wheel solves all these by forcing the spec to always act or query the currect state of the page.
If the page is not in a state that the spec expects, the native Capybara wait will be used until it is; removing the need to `sleep` or build mechanics to test for page loads.

Specs are always written in one uniform, clean, way - always calling the same model when dealing with the same page / element. No more hunting multiple specs to change a selector.

The Element model DSL is still eaily customisable just like "normal" page model classes so domain specfic applications are just as easy, resulting in descriptive, easy to read specs.

## Example spec:

    feature "Supervillan Console" do

     let(:supervillan_console) { SuperVillanConsole.new }

     it 'can destroy the world with the push of a button' do
        supervillan_console.visit do |page|
          page.button_of_doom.should be_present
          page.button_of_doom.click

          # assert that world was destroyed
        end
     end

    end

More spec goodness below.

## Installation

Add this line to your application's Gemfile:

    gem 'capybara-wheel'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capybara-wheel

## Usage

In spec_helper.rb:

    $ require 'capybara/wheel'

**Important: Capybara Wheel overrides Capybara native `feature` method to inject new behavior. This means it should be required instead or Capybara**

## Modeling

### Page Model


To model a new page:

    class NewPage < Capybara::Wheel::Page

A page needs to implement two methods:

    def path
      # implament to support visiting the page directly
      # Rails apps can include Rails.application.routes.url_helpers to access the url helpers
      # Other applications should implament a relative url
    end

  and

    def on_page?
      # Capybara Wheel calls this method before excuting the page block (see Specs section below below)
      # Recommended: Use Wheel native Page method has_title?('Title')
      # e.g. has_title?('Login')

      # Or: Use Capybara.find(any selector you expect would be on a loaded page)
      # e.g. Capybara.find('h1', text: 'Login Page')
    end

**_Example:_**

     class SuperVillanConsole << Capybara::Wheel::Page

       def path
         super_villan_console_path
       end

       def on_page?
         has_title?('Destroy all humans')
       end
     end

***

### Element model

#### Element

Once inside a Page model, it has access to the `element` method.

    element 'ElementName', 'selector' *optional block*

    # Wheel recommends using a name that follows the class constant name convention (i.e CamelCase)
    # as an object will be created and assigned this name (see below)

The `element` method does several important things:

1. It defines a Page method element_name which allows access and initializes...
2. an Element model

Out of the box, Element accepts all the old familar Capybara Element actions / queries (e.g. click, set, text, visible?). Once an action or query is sent to a Wheel element it then finds the native Capybara element and passes it on. This ensures that each method call is executed on the newset version of the element.

Passing a block to element gives access to the Element object for the purpose of implamenting a subelement (see below) or rolling your own customised methods:

**The `capybara_element` method is the direct accessor to the native Capybara element callback.**

**_Example:_**

     element 'ButtonOfDoom', '#doom-button' do

        def armed?
          capybara_element.text == 'Armed'
        end

      end

     element 'MissleTracker', '.missle-tracker'


     #=> SuperVillanConsole.new.button_of_doom.armed?

     #=> SuperVillanConsole.new.missle_tracker.visible?



#### (Sub)Element

An element block also accepts the `element` method.

    element 'SubElementName', 'selector' *optional block*

When called inside an element block, the element behaves like an Element but is now scoped to the containing (or parent) element, which reduces ambiguity.

**_Example:_**

 Two buttons have an `li` element with the `.key` class. We want to be able to find one and turn it without accidently causing world peace:

     element 'ButtonOfDoom', '#doom-button' do

        # reference to this key is scoped inside the #doom-button element
        element 'ArmingKey', 'li.key' do

          def turn
            capybara_element.click
          end

        end
     end

     element 'ButtonOfWorldPeace', '#peace-button' do

       # reference to this key is scoped inside the #peace-button element
       element 'ArmingKey', 'li.key' do

         def turn
           capybara_element.click
         end

       end
     end

     #=> SuperVillanConsole.new.button_of_world_peace.arming_key.turn
     #=> SuperVillanConsole.new.button_of_doom.arming_key.turn

## Specs

Wheel specs are written to always refer to the models and to never refer to Capybara directly. The page methods we implemented above allows us the do:

    let(:some_page) { SomePageModel.new }

    it 'can visit a page' do
      some_page.visit
    end

The visit page would use the `on_page?` method to determine if we are indeed on the page. It will use Capyara's internal wait to poll the page until it is ready. We can then even excute within the scope of the page:

    it 'can visit a page and pass a block to execute' do
      some_page.visit do | page |
        page.some_element.should be_visible
      end
    end

    it 'can also just check if we're on the page without visiting it'
      some_page.on do | page |
        page.some_element.should be_visible
      end
    end


**_Example:_**

    feature "Supervillan Console" do

      let(:supervillan_console) { SuperVillanConsole.new }

      before :each do
        supervillan_console.visit
      end

      scenario 'can arm doom button' do
        supervillan_console.on do | con |
          con.button_of_doom.arming_key.turn
          con.button_of_doom.armed?.should be_true
        end
      end


    end

***
***
***



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
