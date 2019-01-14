# frozen_string_literal: true

module Codebreaker
  RSpec.describe Failing do
    describe '#unexpected difficulty' do
      it { expect(subject.unexpected_difficulty).to eq(I18n.t('error.unexpected_difficulty')) }
    end

    describe '#attempts limit' do
      it { expect(subject.attempts_limit).to eq(I18n.t('error.attempts_limit')) }
    end

    describe '#hints limit' do
      it { expect(subject.hints_limit).to eq(I18n.t('error.hints_limit')) }
    end

    describe '#player name length' do
      let(:name_range) { Player::NAME_LENGTH_RANGE }
      let(:player_name_length_message) do
        I18n.t('error.player_name_length', min_length: name_range.min, max_length: name_range.max)
      end

      it { expect(subject.player_name_length).to eq(player_name_length_message) }
    end

    describe '#secret code length' do
      let(:secret_code_length_message) { I18n.t('error.secret_code_length', code_length: Game::SECRET_CODE_LENGTH) }

      it { expect(subject.secret_code_length).to eq(secret_code_length_message) }
    end

    describe '#secret code digits range' do
      let(:element_range) { Guess::ELEMENT_VALUE_RANGE }
      let(:secret_code_digits_range_message) do
        I18n.t('error.secret_code_digits_range', min_value: element_range.min, max_value: element_range.max)
      end

      it { expect(subject.secret_code_digits_range).to eq(secret_code_digits_range_message) }
    end

    describe '#unexpected option' do
      it { expect { subject.unexpected_option }.to output("#{I18n.t('error.unexpected_option')}\n").to_stdout }
    end

    describe '#unexpected command' do
      it { expect { subject.unexpected_command }.to output("#{I18n.t('error.unexpected_command')}\n").to_stdout }
    end
  end
end
