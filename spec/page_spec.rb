require 'spec_helper'

describe Capybara::Wheel::Page do
  let(:klass) { subject.class }

  describe '.element' do
    it 'creates a subclass for the element and sets up an instance method' do
      expect { klass::RadElement }.to raise_error(NameError, /uninitialized constant/ )
      expect(subject).not_to respond_to(:rad_element)

      klass.element('RadElement', '#rad_element')

      expect { klass::RadElement }.not_to raise_error
      expect(subject.rad_element).to be_a(klass::RadElement)
    end
  end

  describe '#capybara' do
    it 'provides access to the capybara instance' do
      expect(subject.capybara).to be_a Capybara::Session
    end
  end

  describe '#on_page' do
    it 'raises unless implemented' do
      expect { subject.on_page? }.to raise_error(NotImplementedError, /implement me/)
    end
  end

  describe '#path' do
    it 'raises unless implemented' do
      expect { subject.path }.to raise_error(NotImplementedError, /implement me/)
    end
  end

  describe '#on' do
  end

  describe 'visit' do
  end
end
