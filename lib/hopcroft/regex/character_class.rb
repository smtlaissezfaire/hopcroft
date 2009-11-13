module Hopcroft
  module Regex
    class CharacterClass < Base
      class InvalidCharacterClass < StandardError; end

      class << self
        def new(*strs)
          if strs.size == 1 && one_char_long?(strs.first)
            Char.new(strs.first)
          else
            super
          end
        end

      private

        def one_char_long?(str)
          str.size == 1 || (str.size == 2 && str[0] == "\\"[0])
        end
      end

      def initialize(*strs)
        @expressions = strs
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
        @expressions.map { |expr| symbols_for_expr(expr) }.flatten
      end

      def to_regex_s
        "#{OPEN_BRACKET}#{expression_regex}#{CLOSE_BRACKET}"
      end

    private

      def symbols_for_expr(expr)
        if expr.include?("-")
          Range.new(*expr.split("-")).to_a.map { |e| e.to_s }
        else
          expr
        end
      end

      def expression_regex
        @expressions.join("")
      end

      def valid_expression?
        @expressions.all? do |expr|
          if expr.include?("-")
            one, two = expr.split("-")
            two > one
          else
            true
          end
        end
      end

      def invalid_expression?
        !valid_expression?
      end
    end
  end
end
