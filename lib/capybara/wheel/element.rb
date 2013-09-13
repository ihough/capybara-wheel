require 'capybara/wheel/includes'
require 'forwardable'

module Capybara
  module Wheel
    class Element

        extend Forwardable
        include Capybara::Wheel::Includes
        extend Capybara::Wheel::Includes::ClassIncludes

        attr_reader :scope

        def initialize(selector = nil, scope = nil)
          @selector = selector if selector
          @scope    = scope
        end

        def_delegators  :capybara_element,
                        :find,
                        :click,
                        :has_content?,
                        :checked?,
                        :text,
                        :visible?,
                        :present?,
                        :selected?,
                        :disabled?,
                        :tag_name,
                        :value,
                        :set,
                        :select_option,
                        :unselect_option,
                        :hover,
                        :[]



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

        def self.element(name, selector, block = nil)
          subelement_factory = lambda do |parent_element|
            Capybara::Wheel::ElementFactory.create_element(selector, parent_element, block)
          end

          define_method(underscore(name).to_sym) { subelement_factory.call(self) }
          self
        end

        def element(name, selector, &block)
          self.class.element(name, selector, block)
        end

        #TODO: deprecated in 0.0.5
        def subelement(name, selector, &block)
          puts "subelement will be deprecated in future versions."
          puts "Calling element inside an element block will scope it to the parent element"
          element(name, selector, block)
        end

        def self.subelement(name, selector, &block)
          puts "subelement will be deprecated in future versions."
          puts "Calling element inside an element block will scope it to the parent element"
          element(name, selector, &block)
        end

        def selector
          @selector
        end

        private

        # Finds a capybara element representing this thing
        def capybara_element
          scope_capybara.find(selector)
        end

        def scope_capybara
          scope.nil? ? capybara : scope.send(:capybara_element)
        end

    end
  end
end