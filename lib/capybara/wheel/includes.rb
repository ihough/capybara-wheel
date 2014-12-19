require 'capybara/dsl'

module Capybara
  module Wheel
    module Includes
      module ClassIncludes
        # Allow defining an element on a page or within another element
        def element(name, _selector, &block)
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

          # Define .selector and #selector on CurrentClass::ElementName
          klass.singleton_class.class_eval do
            define_method(:selector) { @selector = _selector }
          end
          klass.class_eval do
            def_delegator self, :selector
          end

          # Define CurrentClass#element_name to return an instance of
          # CurrentClass::ElementName whose scope is set to the instance of
          # CurrentClass -- this allows scoping capybara methods
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
