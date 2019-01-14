# frozen_string_literal: true

module Codebreaker
  RSpec.describe Difficulty do
    let(:difficulties) { Difficulty::DIFFICULTIES }
    let(:valid_difficulties) { difficulties.keys.map(&:to_s) }

    describe '#new' do
      let(:empty_array) { [] }

      it do
        valid_difficulties.each do |valid_difficulty|
          difficulty_instance = described_class.new(valid_difficulty)
          expect(difficulty_instance.level).to eq(difficulties[valid_difficulty.to_sym])
          expect(difficulty_instance.instance_variable_get(:@errors)).to eq(empty_array)
        end
      end
    end

    describe 'valid difficulty' do
      Difficulty::DIFFICULTIES.keys.map(&:to_s).each do |valid_difficulty|
        it "when #{valid_difficulty} difficulty" do
          difficulty_instance = described_class.new(valid_difficulty)
          difficulty_instance.validate
          expect(difficulty_instance.errors).to be_empty
          expect(difficulty_instance.valid?).to eq(true)
        end
      end
    end

    describe 'invalid difficulty' do
      let(:errors_array) { [I18n.t('error.unexpected_difficulty')] }
      let(:invalid_difficulty) { valid_difficulties.sample.succ }

      it 'when #validate and #valid? are false' do
        difficulty_instance = described_class.new(invalid_difficulty)
        difficulty_instance.validate
        expect(difficulty_instance.errors).to eq(errors_array)
        expect(difficulty_instance.valid?).to eq(false)
      end
    end

    describe '.list' do
      it { expect(described_class.list).to eq(valid_difficulties.map(&:capitalize)) }
    end
  end
end
