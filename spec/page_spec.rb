require 'spec_helper'

feature 'Page' do
  let(:page) { Capybara::Wheel::Page }

  subject { page.new }
  it { is_expected.to respond_to(:capybara) }

  describe '.element' do

    context 'element with no options' do
      subject { page.element('RadElement', '#rad-selector').new }

      it { is_expected.to respond_to(:rad_element) }
    end

    context 'element with extra options' do
      subject { page.element('OptionalElement', '#opt-selector', visible: false).new }

      it { is_expected.to respond_to(:optional_element) }
      
      it 'has options' do
        expect(subject.optional_element.options).to eq(visible: false)
      end

    end

  end

end
