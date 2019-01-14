# frozen_string_literal: true

module Codebreaker
  module ConsoleUserInteraction
    def options_list
      Console::COMMANDS.values.map(&:capitalize)
    end

    def user_input
      input_value = gets.chomp.downcase
      exit?(input_value) ? exit_from_console : input_value
    end

    def exit_from_console
      output.exit
      exit
    end

    def create_entity(klass)
      loop do
        entity = klass.new(user_input)
        return entity if entity.valid?

        output.display(entity.errors)
      end
    end

    private

    def exit?(input_value)
      input_value == Console::COMMANDS[:exit]
    end
  end
end
