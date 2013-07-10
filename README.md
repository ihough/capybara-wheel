# Capybara::Wheel
> Keeping the rodent on track

Capybara wheel is a page model framework which natively and (hopefully) easily enforces stability coventions:

- No memoization. Every action or query relating to the page should make a new find callback to the actual page.
 - Enforces native Capybara wait time when interacting with the page if the element is not there (yet) or changed.

- No access to capybara directly from the specs.
  - Enforces single point of reference to selectors / elements.
  - Also helps reducing memoizations.

- Subelements structure to scope finds to a specific section of the page.
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

### Element and Subelement model

#### Element

Once inside a Page model, it has access to the `element` method.

    element 'ElementName', 'selector' *optional block*

    # Wheel recommends using a name that follows the class constant name convention (i.e CamelCase)
    # as an object will be created and assigned this name (see below)

The `element` method does several important things:

1. It defines a Page method element_name which allows access and initializes...
2. an Element model

Out of the box, Element accepts all the old familar Capybara Element actions / queries (e.g. click, set, text, visible?). Once an action or query is sent to a Wheel element it then finds the native Capybara element and passes it on. This ensures that each method call is executed on the newset version of the element.

Passing a block to element gives access to the Element object for the purpose of implamenting SubElements (see below) or rolling your own methods:

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



#### Subelement

An element block also accepts the `subelement` method.

    subelement 'SubElementName', 'selector' *optional block*

A subelement behaves exactly like element with one difference, the find is scoped to the containing (or parent) element which reduces ambiguity.

**_Example:_**

 Two buttons have an `li` element with the `.key` class. We want to be able to find one and turn it without accidently causing world peace:

     element 'ButtonOfDoom', '#doom-button' do
        
        # reference to this key is scoped inside the #doom-button element
        subelement 'ArmingKey', 'li.key' do

          def turn
            capybara_element.click
          end

        end
     end

     element 'ButtonOfWorldPeace', '#peace-button' do
       
       # reference to this key is scoped inside the #peace-button element
       subelement 'ArmingKey', 'li.key' do

         def turn
           capybara_element.click
         end

       end
     end

     #=> SuperVillanConsole.new.button_of_world_peace.arming_key.turn
     #=> SuperVillanConsole.new.button_of_doom.arming_key.turn
***
***
***



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
