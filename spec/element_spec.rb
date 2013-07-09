require 'spec_helper'

feature 'Element' do
  let(:element) { Capybara::Wheel::Element }

  it 'has access to capybara' do
    element.new('#some-selector').methods.include?(:capybara).should be_true
  end

  context 'can create a subelement instance' do
    let(:subelement_name)     { 'RadSubElement' }
    let(:subelement_selector) { '#rad-sub-selector' }
    let(:element_instance)    { element.new.subelement(subelement_name, subelement_selector).new('#rad-selector') }

    it 'and create a method for it' do
      element_instance.should respond_to(:rad_sub_element)
    end

    it 'create a subelement with parent element context' do
      element_instance.send(:rad_sub_element).parent.should == element_instance
    end
  end

end