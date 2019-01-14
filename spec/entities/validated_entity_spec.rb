# frozen_string_literal: true

module Codebreaker
  RSpec.describe ValidatedEntity do
    describe '#new' do
      let(:empty_array) { [] }

      it { expect(subject.instance_variable_get(:@errors)).to eq(empty_array) }
    end

    describe '#validate' do
      it { expect { subject.validate }.to raise_error(NotImplementedError) }
    end

    describe '#valid?' do
      it 'checks is validated entity valid' do
        expect(subject).to receive(:validate)
        expect(subject.instance_variable_get(:@errors)).to receive(:empty?)
        subject.valid?
      end
    end

    describe '#failing' do
      let(:failing) { Failing.new }

      it do
        subject.instance_variable_set(:@failing, failing)
        expect(subject.instance_variable_get(:@failing)).to be_an_instance_of(Failing)
      end
    end
  end
end
