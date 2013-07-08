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

> ### Page Model


To model a new page:

    class NewPage < Capybara::Wheel::Page

A page needs two template method implamented:

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

> #### Element and Subelement model

Once inside a Page model, it has access to the `element` method.

    element 'ElementName', 'selector' *optional block*

    # Wheel recommends using a name that follows the class constant name convention (i.e CamelCase)
    # as an object will be created and assigned this name (see below)

The `element` method does several important things:

1. It defines a Page method element_name which allows access and initializes...
2. an Element model

Out of the box, Element accepts all the old familar Capybara Element action / query methods (e.g. click, set, text, visible?) and passes it on to a callback which will find the element on the page and excute the action (or query)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request