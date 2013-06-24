require 'rspec'
require 'capybara/wheel'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.include Capybara::Wheel
end