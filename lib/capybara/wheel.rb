Dir["capybara/wheel"].each {|file| require file }
require "capybara"
require 'capybara/dsl'

module Capybara
  module Wheel
    # main mixin to access wheel

    include Capybara::DSL

    def capybara
      Capybara.current_session
    end

    def self.included(base)
      base.instance_eval do
        alias :background :before
        alias :scenario :it
        alias :given :let
        alias :given! :let!
      end
    end

    module FeatureOverride
      def feature(*args, &block)
        options = {
          type: :wheel,
          caller: caller
        }
        options.merge!(args.pop) if args.last.is_a?(Hash)
        describe(*args, options, &block)
      end
    end

  end
end

extend Capybara::Wheel::FeatureOverride