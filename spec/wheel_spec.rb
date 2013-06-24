require 'spec_helper'
require 'capybara/wheel'

RSpec.configure do |config|
  config.before(:each, :some_hook) do
    @hook_passed_on = true
  end
end

feature 'runs as a wheel feature', :some_hook do
  it 'should pass' do
  end

  it 'should pass the right hook', :some_hook do
    @hook_passed_on.should be_true
  end
end