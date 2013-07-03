require 'capybara/wheel'
require 'capybara'
require 'capybara/dsl'
require 'rspec'

module Capybara
  module Wheel
    module Includes

      include Capybara::DSL

      def capybara
        Capybara.current_session
      end

      module ClassIncludes
        def underscore(string)
          string.gsub(/::/, '/').
                  gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
                  gsub(/([a-z\d])([A-Z])/,'\1_\2').
                  tr("-", "_").
                  downcase
        end

        def make_const(string)

        end
      end

    end
  end
end