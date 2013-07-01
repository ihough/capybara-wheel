require 'capybara/wheel'

module Capybara
  module Wheel
    class ElementFactory

      def self.create_element(selector, block = nil)
        element = Capybara::Wheel::Element.new(selector)
        element.instance_eval(&block) if block

        element
      end

      # element_instance = Capybara::Wheel::Element.new(selector)
      # element_instance.instance_exec do
      #   block.call
      # end if block_given?

      # define_method(name.to_sym) { element_instance }

    end
  end
end
