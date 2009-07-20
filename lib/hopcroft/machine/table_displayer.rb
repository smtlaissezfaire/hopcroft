require "terminal-table"
require "facets/enumerable/map_with_index"

module Hopcroft
  module Machine
    class TableDisplayer
      include Terminal::Table::TableHelper

      def initialize(state_table_hash)
        @state_hash = state_table_hash
      end

      def to_a
        [header, body]
      end

      def header
        converted_table.header.map { |col| col.to_s }
      end

      def body
        converted_table.body.map do |row|
          row.map_with_index do |entry, index|
            if index == 0
              text = entry.name

              text = "-> #{text}" if entry.start_state?
              text = "* #{text}"  if entry.final_state?
              text
            else
              entry.map { |state| state.final? ? "* #{state.name}" : state.name }.join(", ")
            end
          end
        end
      end

      def to_s
        "\n#{table(header, *body).to_s}"
      end

    private

      def converted_table
        @table ||= TableConverter.new(@state_hash)
      end
    end
  end
end
