require 'capybara/wheel'

module Capybara
  module Wheel
    class ElementFactory

      def self.create_element(selector, block = nil)
        element = Capybara::Wheel::Element.new(selector)
        element.instance_eval(&block) if block

        element
      end

      def self.create_subelement(selector, parent_element, block = nil)
        subelement = Capybara::Wheel::SubElement.new(selector, parent_element)
        subelement.instance_eval(&block) if block

        subelement
      end

    end
  end
end
