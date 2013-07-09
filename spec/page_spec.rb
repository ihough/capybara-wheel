require 'spec_helper'

feature 'Page' do
  let(:page) { Capybara::Wheel::Page }

  it 'has access to capybara' do
    page.new.methods.include?(:capybara).should be_true
  end

  context 'can create an element instance' do
    it 'and create a method for it' do
      page.element('RadElement', '#rad-selector').new.should respond_to(:rad_element)
    end
  end

end