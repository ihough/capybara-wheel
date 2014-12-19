require 'capybara/dsl'

module Capybara
  module Wheel
    module Includes
      module ClassIncludes
        # Define an element on a page or within another element
        def element(name, _selector, _options = {}, &block)
          # Create a class inheriting from Capybara::Wheel::Element
          klass = Class.new Capybara::Wheel::Element

          # Name the class CurrentClass::ElementName
          if name.match /\s/
            new_name = name.split(/\s+/).map(&:capitalize).join
            warn "Element name '#{name}' contains whitespace -- changing to '#{new_name}'"
            name = new_name
          end
          unless name.chars.first == name.chars.first.capitalize
            new_name = name.split(/([A-Z]+[a-z]*)/).map(&:capitalize).join
            warn "Element name '#{name}' is not camelcased -- changing to '#{new_name}'"
            name = new_name
          end
          const_set name, klass

          # Define CurrentClass::ElementName#selector and #options
          # These specify how to find the capybara element for this element
          klass.class_eval do
            define_method(:selector) { @selector = _selector }
            define_method(:options) { @options = _options }
          end

          # Define CurrentClass#element_name
          # Returns an instance of CurrentClass::ElementName whose scope is set
          # to the instance of CurrentClass on which the method was called
          define_method(underscore(name).to_sym) { klass.new self }

          # Evaluate any block in the context of CurrentClass::ElementName
          klass.class_eval(&block) if block

          # Return CurrentClass::ElementName
          klass
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
