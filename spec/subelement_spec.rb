require 'spec_helper'

feature 'SubElement' do
  let(:parent_selector) { '#parent-selector'}
  let(:sub_selector)    { '#sub-selector'}
  let!(:parent_element) { Capybara::Wheel::Element.new(parent_selector) }
  let!(:subelement)     { class ASubElement < Capybara::Wheel::SubElement
                              def my_element
                                capybara_element
                              end
                          end }

  before :each do
    parent_element.instance_eval do
      def a_sub_element
        ASubElement.new('#sub-selector', self)
      end
    end
  end

  it 'calls parent element capybara_element' do
    pending
  end

end