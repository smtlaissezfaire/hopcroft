require "terminal-table"
require "facets/enumerable/map_with_index"

module Hopcroft
  module Machine
    class TableDisplayer
      NEWLINE = "\n"
      EMPTY_TABLE_MESSAGE = "Empty table"

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
              text = decorate_start_state(entry)
              decorate_final_state(entry, text)
            else
              entry.map { |state| decorate_final_state(state) }.join(", ")
            end
          end
        end
      end

      def to_s
        returning String.new do |s|
          s << NEWLINE
          s << table
        end
      end

      include Terminal::Table::TableHelper

      def table
        if @state_hash.empty?
          EMPTY_TABLE_MESSAGE
        else
          super(header, *body).to_s
        end
      end

    private

      def decorate_final_state(state, text = state.name)
        state.final? ? "* #{text}" : text
      end

      def decorate_start_state(state)
        state.start_state? ? "-> #{state.name}" : state.name
      end

      def converted_table
        @table ||= TableConverter.new(@state_hash)
      end
    end
  end
end
