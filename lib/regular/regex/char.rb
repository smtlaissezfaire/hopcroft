require "facets/kernel/returning"

module Regular
  module Regex
    class Char
      class InvalidInput < StandardError; end

      def initialize(str)
        raise InvalidInput if str.empty?
        @char = str
      end

      def matches?(char)
        @char == char
      end

      def to_machine
        returning new_machine do |m|
          m.add_transition(@char, :final => true)
        end
      end

    private

      def new_machine
        Machine::State.new
      end
    end
  end
end
