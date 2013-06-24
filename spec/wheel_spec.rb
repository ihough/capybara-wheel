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

  it 'should be set as a wheel feature' do
    example.metadata[:type].should == :wheel
  end

  it 'should pass the right hook' do
    @hook_passed_on.should be_true
  end
end

feature 'Page' do
  let(:page) { Capybara::Wheel::Page }

  its('initializes') { page.new.should be_true }
end

feature 'Element' do
  let(:element) { Capybara::Wheel::Element }

  its('initializes') { element.new('@some-selector').should be_true }
end