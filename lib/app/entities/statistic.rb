# frozen_string_literal: true

module Codebreaker
  class Statistic
    DB_DIR = 'database'
    STATISTIC_FILE_NAME = 'statistic'
    YML_FORMAT = '.yml'

    STATISTIC_YML = DB_DIR + '/' + STATISTIC_FILE_NAME + YML_FORMAT

    def save(player, score)
      new_record = record(player, score)
      save_to_file(new_record)
    end

    def rating_table
      @table = I18n.t(:table)
      table = Terminal::Table.new
      table.title = @table[:title]
      table.headings = @table[:headings]
      table.rows = table_rows
      table
    end

    def load_statistics
      File.exist?(STATISTIC_YML) ? load.each.map { |record| record } : []
    end

    private

    def record(player, score)
      {
        name: player.name,
        difficulty: score.difficulty,
        total_attempts: score.total_attempts,
        used_attempts: score.used_attempts,
        total_hints: score.total_hints,
        used_hints: score.used_hints
      }
    end

    def save_to_file(record)
      File.open(STATISTIC_YML, 'a') { |file| file.write record.to_yaml }
    end

    def table_rows
      File.exist?(STATISTIC_YML) ? load.each_with_index.map { |record, index| rows(record, index) } : []
    end

    def load
      YAML.load_stream(File.read(STATISTIC_YML)).sort_by { |statistic| statistic[:difficulty] }
    end

    def rows(record, index)
      [
        index + 1,
        record[:name],
        record[:difficulty],
        record[:total_attempts],
        record[:used_attempts],
        record[:total_hints],
        record[:used_hints]
      ]
    end
  end
end
