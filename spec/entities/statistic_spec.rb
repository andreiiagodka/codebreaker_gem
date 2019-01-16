# frozen_string_literal: true

module Codebreaker
  RSpec.describe Statistic do
    let(:path) { 'database/test_statistic.yml' }
    let(:difficulty) { Difficulty::DIFFICULTIES.values.sample }

    let(:player) { instance_double('Player', name: 'a' * Player::NAME_LENGTH_RANGE.max) }
    let(:score) do
      instance_double('Game',
                      difficulty: difficulty[:level],
                      total_attempts: difficulty[:attempts],
                      used_attempts: 0,
                      total_hints: difficulty[:hints],
                      used_hints: 0)
    end

    before do
      File.new(path, 'w+')
      stub_const('Statistic::STATISTIC_YML', path)
    end

    after { File.delete(path) }

    describe '#save_to_file' do
      it { expect { subject.save(player, score) }.to change { subject.send(:load).count }.by(1) }
    end

    describe '#load' do
      before { subject.save(player, score) }

      it 'statistic file is not empty' do
        expect(subject.send(:load).empty?).to eq(false)
      end
    end
  end
end
