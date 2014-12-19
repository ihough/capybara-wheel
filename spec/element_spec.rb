require 'spec_helper'

describe Capybara::Wheel::Element do
  let(:page) { Capybara::Wheel::Page.new }

  subject { described_class.new page }

  it 'extends Capybara::Wheel::Includes::ClassIncludes' do
    expect(described_class).to respond_to(:element)
  end

  it 'does not allow scopeless instances' do
    expect { described_class.new }.to raise_error(ArgumentError)
  end

  describe 'Capybara methods' do
    pending 'ensure that any Capybara methods are delegated to #capybara_element'
  end

  describe '#capybara_element' do
    let(:rad_element)  { page.rad_element }
    let(:sub_elem)     { rad_element.sub_elem }
    let(:sub_sub_elem) { sub_elem.sub_sub_elem }

    before :each do
      Capybara::Wheel::Page.element 'RadElement', '#rad_element' do
        element 'SubElem', '.sub_elem' do
          element 'SubSubElem', 'sub_sub'
        end
      end
      allow(page).to receive(:capybara_element) { MockCapybara.new 'Capybara#find' }
    end

    # Undefine the element class and accessor method after each spec - otherwise
    # later tests may fail b/c methods or classes are already defined
    after :each do
      Capybara::Wheel::Page.send :remove_const, :RadElement
      Capybara::Wheel::Page.send :remove_method, :rad_element
    end

    it 'returns the capybara element representing this element' do
      expect(rad_element.capybara_element.path).to  eq('Capybara#find #rad_element')
      expect(sub_elem.capybara_element.path).to     eq('Capybara#find #rad_element .sub_elem')
      expect(sub_sub_elem.capybara_element.path).to eq('Capybara#find #rad_element .sub_elem sub_sub')
    end
  end

  class MockCapybara
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def find(selector)
      self.class.new [path, selector].join(' ')
    end
  end
end
