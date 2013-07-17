require 'capybara/wheel'

module Capybara
  module Wheel
    class ElementFactory

      def self.create_element_klass(selector, block = nil)
        subclass = Class.new(Capybara::Wheel::Element)

        _selector = selector

        subclass.class_exec do
          define_method(:selector) { @selector = _selector}
        end

        subclass.class_eval(&block) if block

        subclass
      end

      #TODO: Pass object not an instance
      def self.create_element(selector, parent_element, block = nil)
        subelement = Capybara::Wheel::Element.new(selector, parent_element)
        subelement.instance_eval(&block) if block

        subelement
      end

    end
  end
end
