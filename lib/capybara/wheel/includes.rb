require 'capybara/wheel'
require 'capybara'
require 'capybara/dsl'
require 'rspec'

#Allows access to Capybara native methods
module Capybara
  module Wheel
    module Includes

      include Capybara::DSL

      def capybara
        Capybara.current_session
      end

    end
  end
end