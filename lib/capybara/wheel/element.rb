require 'capybara/wheel/includes'
require 'forwardable'

module Capybara
  module Wheel
    class Element

        extend Forwardable
        include Capybara::Wheel::Includes
        extend Capybara::Wheel::Includes::ClassIncludes

        def initialize(selector = nil)
          @selector = selector if selector
        end

        def_delegators  :capybara_element,
                        :click,
                        :has_content?,
                        :checked?,
                        :text,
                        :visible?,
                        :present?

        def present?
          capybara_element.visible?
        rescue Capybara::ElementNotFound => e
          puts "#{e} on #{Time.now.strftime("%H:%I:%S:%L")}"
          false
        end

        def visible?
          capybara_element.visible?
        rescue Capybara::ElementNotFound => e
          puts "#{e} on #{Time.now.strftime("%H:%I:%S:%L")}"
          false
        end

        def self.subelement(name, selector, block = nil)
          subelement_factory = lambda do |parent_element|
            Capybara::Wheel::ElementFactory.create_subelement(selector, parent_element, block)
          end

          define_method(underscore(name).to_sym) { subelement_factory.call(self) }
          self
        end

        def subelement(name, selector, &block)
          self.class.subelement(name, selector, block)
        end

        def selector
          @selector
        end

        protected

        # Finds a capybara element representing this thing
        def capybara_element
          capybara.find(selector)
        end

    end
  end
end