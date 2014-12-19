require 'spec_helper'

RSpec.configure do |config|
  config.before(:each, :some_hook) do
    @hook_passed_on = true
  end
end

feature 'runs as a wheel feature', :some_hook do
  it 'should pass' do
  end

  it 'should be set as a wheel feature' do |example|
    expect(example.metadata[:type]).to eq(:wheel_feature)
  end

  it 'should pass the right hook' do
    expect(@hook_passed_on).to be true
  end
end
