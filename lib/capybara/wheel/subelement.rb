require 'capybara/wheel/includes'

module Capybara
  module Wheel
    class SubElement < Capybara::Wheel::Element
      attr_reader :parent

      def initialize(selector, parent)
        @parent   = parent
        @selector =  selector
      end

      private
      def capybara_element
        parent_element.find(selector)
      end

      def parent_element
        parent.send(:capybara_element)
      end

    end
  end
end