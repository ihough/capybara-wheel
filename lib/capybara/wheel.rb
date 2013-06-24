require "capybara/wheel/version"
require "capybara"
require 'capybara/dsl'

def self.feature(*args, &block)
  options = {
    type: :wheel,
    caller: caller
  }
  options.merge!(args.pop) if args.last.is_a?(Hash)
  describe(*args, options, &block)
end

module Capybara
  module Wheel
    # main mixin to access wheel

    include Capybara::DSL
    include Rails.application.routes.url_helpers

    def capybara
      Capybara.current_session
    end

    def self.included(klass)
      klass.instance_eval do
        alias :background :before
        alias :scenario :it
        alias :given :let
        alias :given! :let!
      end
    end


  end
end
