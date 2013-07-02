require 'capybara/wheel/includes'
require 'forwardable'

module Capybara
  module Wheel
    class Element

        extend Forwardable
        include Capybara::Wheel::Includes

        def initialize(selector)
          @selector = selector
        end

        def_delegators  :capybara_element,
                        :click,
                        :has_content?,
                        :checked?,
                        :text,
                        :visible?,
                        :present?

        def present?
          begin
            capybara_element.visible?
          rescue Capybara::ElementNotFound => e
            puts "#{e} on #{Time.now.strftime("%H:%I:%S:%L")}"
            false
          end
        end

        def visible?
          begin
            capybara_element.visible?
          rescue Capybara::ElementNotFound => e
            puts "#{e} on #{Time.now.strftime("%H:%I:%S:%L")}"
            false
          end
        end

        def self.subelement(name, selector, &block)
          subelement_factory = lambda do |parent_element|
            Capybara::Wheel::ElementFactory.create_subelement(selector, parent_element, block)
          end

          define_method(name.downcase.to_sym) { subelement_factory.call(self) }
          self
        end

        protected

        # Finds a capybara element representing this thing
        def capybara_element
          capybara.find(selector)
        end

        def selector
          @selector
        end

    end
  end
end
