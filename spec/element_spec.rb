require 'spec_helper'

feature 'Element' do
  let(:element_selector)  { '#some-selector' }
  let(:element)           { Capybara::Wheel::Element }
  let(:element_instance)  {  element.new(element_selector) }

  it 'has access to capybara' do
    element_instance.methods.include?(:capybara).should be_true
  end

  it 'has delegators for Capybara actions' do
    pending 'grab all the actions from Capybara and ensure delegators are implemented'
  end

  context 'self.element' do
    let(:element_selector)    { '#rad-parent-selector' }

    let(:subelement_name)     { 'RadSubElement' }
    let(:subelement_selector) { '#rad-sub-selector' }

    before do
      element_instance.instance_eval do
        element('RadSubElement', '#rad-sub-selector')
      end
    end

    it 'created a method for calling the element' do
      element_instance.should respond_to(:rad_sub_element)
    end

    it 'create a (sub)element with parent element context' do
      element_instance.send(:rad_sub_element).scope.should == element_instance
    end

    it 'the find would be scoped to parent' do
      subelement             = element_instance.send(:rad_sub_element)
      mock_capybara_session  = mock(Capybara::Session)
      mock_capybara_element  = mock('Capybara::Element')
      Capybara.stub!(:current_session).and_return(mock_capybara_session)
      mock_capybara_session.stub(:find).with(element_selector).and_return(mock_capybara_element)
      mock_capybara_element.stub(:find).with(subelement_selector).and_return(mock_capybara_element)

      element_instance.should_receive(:capybara_element).once.and_return(mock_capybara_element)

      subelement.send(:capybara_element)
    end
  end

end