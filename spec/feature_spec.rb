require 'spec_helper'

RSpec.configure do |config|
  config.before(:each, :some_hook) do
    @hook_passed_on = true
  end
end

feature 'runs as a wheel feature', :some_hook do

  it 'should pass' do
  end

  it 'should be set as a wheel feature' do
    example.metadata[:type].should == :wheel_feature
  end

  it 'should pass the right hook' do
    @hook_passed_on.should be_true
  end
end