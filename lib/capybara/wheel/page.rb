require 'capybara/wheel/includes'

module Capybara
  module Wheel
    class Page
      include Capybara::Wheel::Includes
      extend Capybara::Wheel::Includes::ClassIncludes

      # Access to capybara
      def capybara
        Capybara.current_session
      end
      alias_method :capybara_element, :capybara

      # Execute a block in the context of this page
      def on
        unless on_page?
          raise "We don't appear to be on the #{self.class}"
        end
        yield self if block_given?
        self
      end

      # Return true if the browser is on this page
      def on_page?
        raise NotImplementedError, "implement me, e.g. using #has_title?"
      end

      # Return the path (relative URI) of this page
      def path
        raise NotImplementedError, "implement me to support page.visit, e.g. '/relatve_URI_of_this_page'"
      end

      # Visit the page and executes a block in its context
      def visit(&block)
        capybara.visit path
        if block_given?
          on &block
        else
          on_page?
        end
        return self
      end
    end
  end
end
