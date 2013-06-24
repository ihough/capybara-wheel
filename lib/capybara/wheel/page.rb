module Capybara
  module Wheel
    module Page

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
          raise "We don't appear to be on #{description}"
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

    end
  end
end