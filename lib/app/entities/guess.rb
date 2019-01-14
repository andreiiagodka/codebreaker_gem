# frozen_string_literal: true

module Codebreaker
  class Guess < ValidatedEntity
    attr_reader :guess_code, :errors

    ELEMENT_VALUE_RANGE = (1..6).freeze

    HINT = 'hint'

    def initialize(guess_code)
      super()
      @guess_code = guess_code
    end

    def validate
      return if hint?

      @errors << failing.secret_code_length unless check_length
      @errors << failing.secret_code_digits_range unless check_digits_range
    end

    def hint?
      @guess_code == HINT
    end

    private

    def check_length
      @guess_code.length == Game::SECRET_CODE_LENGTH
    end

    def check_digits_range
      @guess_code.each_char { |digit| break unless ELEMENT_VALUE_RANGE.include?(digit.to_i) }
    end
  end
end
