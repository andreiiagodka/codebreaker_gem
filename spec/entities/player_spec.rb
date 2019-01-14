# frozen_string_literal: true

module Codebreaker
  RSpec.describe Player do
    subject(:player) { described_class.new(valid_name) }

    let(:valid_name) { 'a' * Player::NAME_LENGTH_RANGE.max }

    describe '#new' do
      let(:empty_array) { [] }

      it { expect(player.name).to eq(valid_name) }
      it { expect(player.instance_variable_get(:@errors)).to eq(empty_array) }
    end

    describe 'valid player name' do
      before { player.validate }

      it 'when #validate is true' do
        expect(player.errors).to be_empty
      end

      it 'when #valid? is true' do
        expect(player.valid?).to eq(true)
      end
    end

    describe 'invalid player name' do
      let(:invalid_name) { 'a' * (Player::NAME_LENGTH_RANGE.max + 1) }
      let(:errors_array) do
        [I18n.t('error.player_name_length',
                min_length: Player::NAME_LENGTH_RANGE.min,
                max_length: Player::NAME_LENGTH_RANGE.max)]
      end

      before do
        player.instance_variable_set(:@name, invalid_name)
        player.validate
      end

      it 'when #validate is false' do
        expect(player.errors).to eq(errors_array)
      end

      it 'when #valid? is false' do
        expect(player.valid?).to eq(false)
      end
    end
  end
end
