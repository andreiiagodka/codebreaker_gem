# frozen_string_literal: true

module Codebreaker
  class Game
    attr_reader :difficulty, :total_attempts, :used_attempts, :total_hints, :used_hints, :secret_code

    SECRET_CODE_LENGTH = 4
    ELEMENT_VALUE_RANGE = (1..6).freeze

    DELIMITER = ''
    EXACT_MATCH = '+'
    NUMBER_MATCH = '-'

    def initialize(difficulty)
      @difficulty = difficulty[:level]
      @total_attempts = difficulty[:attempts]
      @used_attempts = 0
      @total_hints = difficulty[:hints]
      @used_hints = 0
      @secret_code = generate
      @shuffled_code = @secret_code.shuffle
    end

    def use_hint
      increment_used_hints
      @shuffled_code.shift
    end

    def hints_available?
      @used_hints >= @total_hints
    end

    def win?(guess_code)
      guess_code == convert_to_string(@secret_code)
    end

    def loss?
      @used_attempts == @total_attempts
    end

    def increment_used_attempts
      @used_attempts += 1
    end

    def mark_guess(guess_code)
      @converted_input = convert_to_digit_array(guess_code)
      @cloned_code = @secret_code.clone
      convert_to_string(exact_match.compact + number_match.compact)
    end

    private

    def generate
      Array.new(SECRET_CODE_LENGTH) { rand(ELEMENT_VALUE_RANGE) }
    end

    def increment_used_hints
      @used_hints += 1
    end

    def convert_to_string(argument)
      argument.join
    end

    def convert_to_digit_array(guess_code)
      guess_code.split(DELIMITER).map(&:to_i)
    end

    def exact_match
      @converted_input.map.with_index do |digit, index|
        next unless @cloned_code[index] == digit

        @converted_input[index] = nil
        @cloned_code[index] = nil
        EXACT_MATCH
      end
    end

    def number_match
      @converted_input.compact.map do |digit|
        next unless @cloned_code.include?(digit)

        @cloned_code.delete_at(@cloned_code.index(digit))
        NUMBER_MATCH
      end
    end

    def convert_marked_guess
      convert_to_string(@cloned_code.grep(String).sort)
    end
  end
end
