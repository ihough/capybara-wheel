require 'spec_helper'

describe Capybara::Wheel::Page do
  it 'extends Capybara::Wheel::Includes::ClassIncludes' do
    expect(described_class).to respond_to(:element)
  end

  describe '#capybara' do
    it 'provides access to the capybara instance' do
      expect(subject.capybara).to be_a Capybara::Session
    end
  end

  describe '#capybara_element' do
    it 'is an alias for #capybara' do
      expect(subject.capybara_element).to eq(subject.capybara)
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
    pending 'TODO'
  end

  describe 'visit' do
    pending 'TODO'
  end
end
