require 'capybara/wheel/includes'
require 'forwardable'

module Capybara
  module Wheel
    class Element
      include Capybara::Wheel::Includes
      extend Capybara::Wheel::Includes::ClassIncludes
      extend Forwardable

      attr_reader :scope

      def initialize(scope)
        @scope = scope
      end

      def_delegators :capybara_element,
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

      # Finds a capybara element representing this element
      def capybara_element
        scope.capybara_element.find selector
      end
    end
  end
end
