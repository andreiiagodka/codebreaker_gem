# frozen_string_literal: true

module Codebreaker
  class Output < OutputHelper
    MESSAGE = 'message'

    def introduction
      message(:introduction)
    end

    def rules
      message(:rules)
    end

    def registration
      message(:registration_heading)
      message(:player_name_registration)
    end

    def game_start_heading
      message(:game_start_heading)
    end

    def difficulty_heading
      message(:difficulty_heading)
      display(Difficulty.list)
    end

    def win
      message(:win)
    end

    def exit
      message(:exit)
    end

    def statistics(game)
      message(:statistics,
              used_attempts: game.used_attempts,
              total_attempts: game.total_attempts,
              used_hints: game.used_hints,
              total_hints: game.total_hints)
      message(:input_secret_code)
    end

    def save_result
      message(:save_result)
    end

    def start_new_game
      message(:start_new_game)
    end

    private

    def message(message, *parameters)
      display(get(MESSAGE, message, *parameters))
    end
  end
end
