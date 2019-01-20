# frozen_string_literal: true

module Codebreaker
  RSpec.describe Game do
    subject(:game) { described_class.new(difficulty) }

    let(:difficulty) { Difficulty::DIFFICULTIES[list_of_difficulties.sample] }
    let(:list_of_difficulties) { Difficulty::DIFFICULTIES.keys }

    describe '#new' do
      it { expect(game.difficulty).to eq(difficulty[:level]) }
      it { expect(game.total_attempts).to eq(difficulty[:attempts]) }
      it { expect(game.used_attempts).to eq(0) }
      it { expect(game.total_hints).to eq(difficulty[:hints]) }
      it { expect(game.used_hints).to eq(0) }
    end

    describe '#use_hint' do
      it 'increments used hints' do
        expect { game.use_hint }.to change(game, :used_hints).by(1)
        game.use_hint
      end
    end

    describe '#hints_available?' do
      it 'hints are available' do
        game.instance_variable_set(:@used_hints, game.total_hints)
        expect(game.hints_available?).to eq true
      end

      it 'hints are not available' do
        expect(game.hints_available?).to eq false
      end
    end

    describe '#win?' do
      let(:secret_code) { Array.new(Game::SECRET_CODE_LENGTH) { rand(Game::ELEMENT_VALUE_RANGE) } }
      let(:not_winning_code) { '7777' }

      before { game.instance_variable_set(:@secret_code, secret_code) }

      it 'when winning combination' do
        expect(game.win?(secret_code.join)).to eq true
      end

      it 'when not winning combination' do
        expect(game.win?(not_winning_code)).to eq false
      end
    end

    describe '#loss?' do
      it 'when lose' do
        game.instance_variable_set(:@used_attempts, game.total_attempts)
        expect(game.loss?).to eq true
      end

      it 'when dont lose' do
        expect(game.loss?).to eq false
      end
    end

    describe '#increment used attempts' do
      it { expect { game.increment_used_attempts }.to change(game, :used_attempts).by(1) }
    end

    describe '#mark_guess' do
      [
        [[6, 5, 4, 1], [6, 5, 4, 1], [Game::EXACT_MATCH, Game::EXACT_MATCH, Game::EXACT_MATCH, Game::EXACT_MATCH]],
        [[1, 2, 2, 1], [2, 1, 1, 2], [Game::NUMBER_MATCH, Game::NUMBER_MATCH,
                                      Game::NUMBER_MATCH, Game::NUMBER_MATCH]],
        [[6, 2, 3, 5], [2, 3, 6, 5], [Game::EXACT_MATCH, Game::NUMBER_MATCH,
                                      Game::NUMBER_MATCH, Game::NUMBER_MATCH]],
        [[1, 2, 3, 4], [4, 3, 2, 1], [Game::NUMBER_MATCH, Game::NUMBER_MATCH,
                                      Game::NUMBER_MATCH, Game::NUMBER_MATCH]],
        [[1, 2, 3, 4], [1, 2, 3, 5], [Game::EXACT_MATCH, Game::EXACT_MATCH, Game::EXACT_MATCH]],
        [[1, 2, 3, 4], [5, 4, 3, 1], [Game::EXACT_MATCH, Game::NUMBER_MATCH, Game::NUMBER_MATCH]],
        [[1, 2, 3, 4], [1, 5, 2, 4], [Game::EXACT_MATCH, Game::EXACT_MATCH, Game::NUMBER_MATCH]],
        [[1, 2, 3, 4], [4, 3, 2, 6], [Game::NUMBER_MATCH, Game::NUMBER_MATCH, Game::NUMBER_MATCH]],
        [[1, 2, 3, 4], [3, 5, 2, 5], [Game::NUMBER_MATCH, Game::NUMBER_MATCH]],
        [[1, 2, 3, 4], [5, 6, 1, 2], [Game::NUMBER_MATCH, Game::NUMBER_MATCH]],
        [[5, 5, 6, 6], [5, 6, 0, 0], [Game::EXACT_MATCH, Game::NUMBER_MATCH]],
        [[1, 2, 3, 4], [6, 2, 5, 4], [Game::EXACT_MATCH, Game::EXACT_MATCH]],
        [[1, 2, 3, 1], [1, 1, 1, 1], [Game::EXACT_MATCH, Game::EXACT_MATCH]],
        [[1, 1, 1, 5], [1, 2, 3, 1], [Game::EXACT_MATCH, Game::NUMBER_MATCH]],
        [[1, 2, 3, 4], [4, 2, 5, 5], [Game::EXACT_MATCH, Game::NUMBER_MATCH]],
        [[1, 2, 3, 4], [5, 6, 3, 5], [Game::EXACT_MATCH]],
        [[1, 2, 3, 4], [6, 6, 6, 6], []],
        [[1, 2, 3, 4], [2, 5, 5, 2], [Game::NUMBER_MATCH]]
      ].each do |item|
        it "when result is #{item[2]} if code is - #{item[0]}, guess is #{item[1]}" do
          game.instance_variable_set(:@secret_code, item[0])
          guess = item[1]
          expect(game.mark_guess(guess.join)).to eq item[2]
        end
      end
    end
  end
end
