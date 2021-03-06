require 'spec_helper'

shared_examples 'a model that includes Capybara::Wheel::Includes::ClassIncludes' do
  describe '.underscore(string)' do
    it 'downcases and underscores a string' do
      string = 'StringToUnderscore'
      result = 'string_to_underscore'
      expect(described_class.underscore(string)).to eq(result)
    end
  end

  describe '.element' do
    let(:name) { 'RadElement' }
    let(:selector) { '#rad_element' }
    let(:accessor) { :rad_element }
    let(:element_class) { described_class.element name, selector }
    let(:element_instance) { subject.send accessor }

    # Undefine the element class and accessor method after each spec -
    # otherwise later tests may fail b/c methods or classes are already defined
    after :each do
      described_class.send :remove_const, name.to_sym
      described_class.send :remove_method, accessor
    end

    describe 'returns a class for the element that' do
      it 'inherits from Capybara::Wheel::Element' do
        expect(element_class.superclass).to eq(Capybara::Wheel::Element)
      end

      it 'does not inherit from Capybara::Wheel::Page' do
        expect(element_class.ancestors).not_to include(Capybara::Wheel::Page)
      end

      it 'is named as if it were a subclass of this class' do
        expect(element_class.name).to eq([described_class.name, name].join('::'))
      end

      it 'has a #selector method that returns the specified selector' do
        expect(element_class.instance_methods).to include(:selector)
        expect(element_instance.selector).to eq(selector)
      end
    end

    describe 'handles bad element names' do
      it 'containing whitespace' do
        bad_name = "Rad \t\nElement"
        element_class = described_class.element bad_name, selector
        expect(element_class.name).to eq([described_class.name, name].join('::'))
      end

      it 'uncapitalized' do
        bad_name = 'radElement'
        element_class = described_class.element bad_name, selector
        expect(element_class.name).to eq([described_class.name, name].join('::'))
      end

      it 'whitespace uncapitalized' do
        bad_name = 'rad element'
        element_class = described_class.element bad_name, selector
        expect(element_class.name).to eq([described_class.name, name].join('::'))
      end
    end

    it 'defines an instance method on this class that returns a scoped element instance' do
      expect(subject).not_to respond_to(accessor)
      expect { element_class }.to change { described_class.instance_methods.length }.by(1)

      expect(element_instance).to be_a(element_class)
      expect(element_instance.scope).to be(subject)
    end

    describe 'accepts options' do
      let(:options) { { visible: false } }
      let(:element_class) { described_class.element name, selector, options }

      it 'sets a #options method on the element class' do
        expect(element_class.instance_methods).to include(:options)
        expect(element_instance.options).to eq(visible: false)
      end
    end

    describe 'accepts a block' do
      let(:element_class) { described_class.element name, selector, &block }

      context 'method block' do
        let!(:element_class) {
          described_class.element name, selector do
            def rad_method
            end
          end
        }

        it 'defines the method on the element class' do
          expect(element_instance).to respond_to(:rad_method)
        end
      end

      context 'element block' do
        let!(:element_class) {
          described_class.element name, selector do
            element 'SubElem', '.sub_elem'
          end
        }
        let(:sub_instance) { element_instance.sub_elem }

        it 'defines the subelement as scoped within the element' do
          expect(element_instance).to respond_to(:sub_elem)
          expect(sub_instance.class.name).to eq([element_class.name, 'SubElem'].join('::'))
          expect(sub_instance.selector).to eq('.sub_elem')
          expect(sub_instance.scope).to eq(element_instance)
        end
      end

      context 'blocks within blocks' do
        let!(:element_class) {
          described_class.element name, selector do
            element 'SubElem', '.sub_elem' do
              element 'SubSubElem', 'sub_sub_elem' do
                def sub_sub_method
                end
              end
            end
          end
        }
        let(:sub_instance) { element_instance.sub_elem }
        let(:sub_sub_instance) { sub_instance.sub_sub_elem }

        it 'defines everything' do
          # SubElem
          expect(element_instance).to respond_to(:sub_elem)
          expect(sub_instance.class.name).to eq([element_class.name, 'SubElem'].join('::'))
          expect(sub_instance.selector).to eq('.sub_elem')
          expect(sub_instance.scope).to eq(element_instance)

          # SubSubElem
          expect(sub_instance).to respond_to(:sub_sub_elem)
          expect(sub_sub_instance.class.name).to eq([sub_instance.class.name, 'SubSubElem'].join('::'))
          expect(sub_sub_instance.selector).to eq('sub_sub_elem')
          expect(sub_sub_instance.scope).to eq(sub_instance)
        end
      end
    end
  end
end

describe Capybara::Wheel::Page do
  it_behaves_like 'a model that includes Capybara::Wheel::Includes::ClassIncludes'
end

describe Capybara::Wheel::Element do
  let(:page) { Capybara::Wheel::Page.new }

  subject { described_class.new page }

  it_behaves_like 'a model that includes Capybara::Wheel::Includes::ClassIncludes'
end
