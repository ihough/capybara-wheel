require 'capybara/wheel/includes'
require 'forwardable'

module Capybara
  module Wheel
    class Element
      extend Capybara::Wheel::Includes::ClassIncludes
      extend Forwardable

      attr_reader :scope

      def initialize(scope)
        @scope = scope
      end

      # Delegate Capybara::DSL methods to the capybara element representing this
      # element. The Capybara::DSL methods cover most methods defined in:
      #   Capybara::Node::Actions
      #   Capybara::Node::Finders
      #   Capybara::Node::Matchers
      Capybara::Session::NODE_METHODS.each do |method|
        def_delegator :capybara_element, method
      end

      # Delegate methods defined in Capybara::Node::Element to the capybara
      # element representing this element. These need to be explicitly
      # delegated because they are not included in the Capybara::DSL methods
      def_delegators :capybara_element,
        :checked?,
        :click,
        :disabled?,
        :double_click,
        :drag_to,
        :hover,
        :path,
        :present?,
        :reload,
        :right_click,
        :selected?,
        :select_option,
        :set,
        :tag_name,
        :trigger,
        :unselect_option,
        :value,
        :visible?,
        :[]

      # Finds a capybara element representing this element
      def capybara_element
        scope.capybara_element.find selector
      end
    end
  end
end
