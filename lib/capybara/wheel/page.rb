require 'capybara/wheel/includes'

module Capybara
  module Wheel
    class Page

      include Capybara::Wheel::Includes
      extend Capybara::Wheel::Includes::ClassIncludes

      # actively visits page and executes block in context
      def visit(&block)
        capybara.visit(path)
        if block_given?
          on(&block)
        else
          on_page?
        end
        return self
      end

      # execute a block in the context of this page
      def on
        unless on_page?
          raise "We don't appear to be on the #{self.class}"
        end
        yield self if block_given?
        self
      end

      # Returns the path (relative URI) of this page
      def path
        raise NotImplementedError, "implement to support page.visit"
      end

      # Return true if the browser is on this page
      def on_page?
        raise NotImplementedError, "implement me, e.g. using #has_title?"
      end

      def has_title?(expected_title)
        capybara.has_css?("head title", text: expected_title)
      end

      def self.element(name, selector, options = {}, &block)
        begin
          element_klass = const_set("#{name}", Capybara::Wheel::ElementFactory.create_element_klass(selector, options, block))
        rescue NameError
          puts "We recommend using capitalized element and subelement names"
          name = name.capitalize!
          retry
        end

        define_method(underscore(name).to_sym) { element_klass.new(selector) }
        self
      end

    end
  end
end
