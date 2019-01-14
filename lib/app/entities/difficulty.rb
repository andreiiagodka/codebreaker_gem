# frozen_string_literal: true

module Codebreaker
  class Difficulty < ValidatedEntity
    attr_reader :level, :errors

    DIFFICULTIES = {
      easy: {
        level: 'easy',
        attempts: 15,
        hints: 3
      },

      medium: {
        level: 'medium',
        attempts: 10,
        hints: 1
      },

      hard: {
        level: 'hard',
        attempts: 5,
        hints: 1
      }
    }.freeze

    def initialize(difficulty)
      super()
      @level = DIFFICULTIES[difficulty.to_sym]
    end

    def validate
      @errors << failing.unexpected_difficulty if check_difficulty
    end

    def self.list
      DIFFICULTIES.keys.map(&:to_s).map(&:capitalize)
    end

    private

    def check_difficulty
      @level.nil?
    end
  end
end
