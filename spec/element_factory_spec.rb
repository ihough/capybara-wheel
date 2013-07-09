require 'spec_helper'

feature 'ElementFactory' do
  let(:subject)               { Capybara::Wheel::ElementFactory }
  let(:selector)              { '#rad-selector'}
  let(:created_element_klass) { subject.create_element_klass(selector) }


  it 'creates an element' do
    created_element_klass.superclass.should == Capybara::Wheel::Element
  end

  it 'allows access to the selector' do
    created_element_klass.new.selector.should == selector
  end

  it 'generated instance evalutes block' do
    test_block = Proc.new do
      def evaled_method
      end
    end

    subject.create_element_klass(selector, test_block).new.should respond_to(:evaled_method)
  end
end