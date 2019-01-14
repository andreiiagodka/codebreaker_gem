# frozen_string_literal: true

module Codebreaker
  RSpec.describe Guess do
    subject(:guess) { described_class.new(input_guess_code) }

    let(:guess_code) { Array.new(Game::SECRET_CODE_LENGTH) { rand(Game::ELEMENT_VALUE_RANGE) } }
    let(:input_guess_code) { guess_code.join }
    let(:hint) { Guess::HINT }

    describe '#new' do
      let(:empty_array) { [] }

      it { expect(guess.guess_code).to eq(input_guess_code) }
      it { expect(guess.instance_variable_get(:@errors)).to eq(empty_array) }
    end

    describe 'valid guess code' do
      before { guess.validate }

      it 'when #validate is true' do
        expect(guess.errors).to be_empty
      end

      it 'when #valid? is true' do
        expect(guess.valid?).to eq(true)
      end
    end

    describe 'invalid guess code' do
      describe 'guess code is too short' do
        let(:too_short_guess_code) { input_guess_code.chop }
        let(:length_error_message) { I18n.t('error.secret_code_length', code_length: Game::SECRET_CODE_LENGTH) }

        before do
          guess.instance_variable_set(:@guess_code, too_short_guess_code)
          guess.validate
        end

        it 'when #validate is false' do
          expect(guess.errors).to eq([length_error_message])
        end

        it 'when #valid? is false' do
          expect(guess.valid?).to eq(false)
        end
      end

      describe 'guess code digits are not in range' do
        let(:invalid_range_guess_code) { Array.new(Game::SECRET_CODE_LENGTH) { rand(invalid_element_value_range) } }
        let(:invalid_element_value_range) { (7..9) }
        let(:digits_range_error_message) do
          I18n.t('error.secret_code_digits_range',
                 min_value: Guess::ELEMENT_VALUE_RANGE.min,
                 max_value: Guess::ELEMENT_VALUE_RANGE.max)
        end

        before do
          guess.instance_variable_set(:@guess_code, invalid_range_guess_code.join)
          guess.validate
        end

        it 'when #validate is false' do
          expect(guess.errors).to eq([digits_range_error_message])
        end

        it 'when #valid? is false' do
          expect(guess.valid?).to eq(false)
        end
      end
    end

    describe 'guess code is hint' do
      before do
        guess.instance_variable_set(:@guess_code, hint)
        guess.validate
      end

      it 'when #validate is true' do
        expect(guess.errors).to be_empty
      end

      it 'when #valid? is true' do
        expect(guess.valid?).to eq(true)
      end
    end

    describe '#hint?' do
      it 'when hint' do
        guess.instance_variable_set(:@guess_code, hint)
        expect(guess.instance_variable_get(:@guess_code)).to eq(hint)
      end

      it 'when not hint' do
        expect(guess.instance_variable_get(:@guess_code)).to eq(input_guess_code)
      end
    end
  end
end
