module Hopcroft
  module Regex
    class CharacterClass < Base
      class InvalidCharacterClass < StandardError; end

      def initialize(str)
        super
        raise InvalidCharacterClass if invalid_expression?
      end

      def matches?(str)
        to_machine.matches?(str)
      end

      def to_machine
        new_machine do |machine|
          machine.use_start_state do |start_state|
            each_symbol do |sym|
              start_state.add_transition :symbol => sym, :final => true
            end
          end
        end
      end

      def each_symbol(&block)
        symbols.each(&block)
      end

      def symbols
        start, finish = expression.split("-")
        Range.new(start, finish).to_a.map { |e| e.to_s }
      end

      def to_regex_s
        "#{OPEN_BRACKET}#{expression}#{CLOSE_BRACKET}"
      end

    private

      def valid_expression?
        if expression.include?("-")
          one, two = expression.split("-")
          two > one
        else
          true
        end
      end

      def invalid_expression?
        !valid_expression?
      end
    end
  end
end
