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


  end
end
