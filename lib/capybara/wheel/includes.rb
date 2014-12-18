require 'capybara/dsl'

module Capybara
  module Wheel
    module Includes
      include Capybara::DSL

      module ClassIncludes
        # Allow defining an element on a page or within another element
        def element(name, _selector, &block)
          # Set up the element as CurrentClass::ElementName
          klass = Class.new Capybara::Wheel::Element
          begin
            const_set name, klass
          rescue NameError
            puts "Cannot create class '#{name}' -- trying '#{name.capitalize}'"
            name.capitalize!
            retry
          end

          # Define ElementName.selector and ElementName#selector
          klass.singleton_class.class_eval do
            define_method(:selector) { @selector = _selector }
          end
          klass.class_eval do
            def_delegator self, :selector
          end

          # Define CurrentClass#element_name to return an ElementName instance
          # whose selector will be scoped to within CurrentClass' selector
          define_method(underscore(name).to_sym) { klass.new self }

          # Define any subelements and methods on ElementName
          klass.class_eval(&block) if block
        end

        # For use by .element -- from rails String#underscore
        def underscore(string)
          string.gsub(/::/, '/').
                  gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
                  gsub(/([a-z\d])([A-Z])/,'\1_\2').
                  tr("-", "_").
                  downcase
        end
      end
    end
  end
end
