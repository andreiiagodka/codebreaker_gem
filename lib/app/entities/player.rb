# frozen_string_literal: true

module Codebreaker
  class Player < ValidatedEntity
    attr_reader :name, :errors

    NAME_LENGTH_RANGE = (3..20).freeze

    def initialize(name)
      super()
      @name = name
    end

    def validate
      @errors << failing.player_name_length unless check_name_length
    end

    private

    def check_name_length
      NAME_LENGTH_RANGE.include?(@name.length)
    end
  end
end
