module Hopcroft
  module Regex
    class CharacterClass < Base
      class InvalidCharacterClass < StandardError; end

      class << self
        def new(str)
          one_char_long?(str) ? Char.new(str) : super
        end

      private

        def one_char_long?(str)
          str.size == 1 || (str.size == 2 && str[0] == "\\"[0])
        end
      end

      def initialize(str)
        super
        raise InvalidCharacterClass if invalid_expression?
      end

      def build_machine(start_state)
        each_symbol do |sym|
          start_state.add_transition :symbol => sym, :final => true
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
        one, two = expression.split("-")
        two > one
      end

      def invalid_expression?
        !valid_expression?
      end
    end
  end
end
