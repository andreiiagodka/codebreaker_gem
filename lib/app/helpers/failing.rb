# frozen_string_literal: true

module Codebreaker
  class Failing < OutputHelper
    ERROR = 'error'

    def unexpected_difficulty
      error(:unexpected_difficulty)
    end

    def attempts_limit
      error(:attempts_limit)
    end

    def hints_limit
      error(:hints_limit)
    end

    def player_name_length
      error(:player_name_length,
            min_length: Player::NAME_LENGTH_RANGE.min,
            max_length: Player::NAME_LENGTH_RANGE.max)
    end

    def secret_code_length
      error(:secret_code_length,
            code_length: Game::SECRET_CODE_LENGTH)
    end

    def secret_code_digits_range
      error(:secret_code_digits_range,
            min_value: Guess::ELEMENT_VALUE_RANGE.min,
            max_value: Guess::ELEMENT_VALUE_RANGE.max)
    end

    def unexpected_option
      display(error(:unexpected_option))
    end

    def unexpected_command
      display(error(:unexpected_command))
    end

    private

    def error(error, *parameters)
      get(ERROR, error, *parameters)
    end
  end
end
