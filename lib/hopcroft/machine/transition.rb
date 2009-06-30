module Hopcroft
  module Machine
    class Transition
      def initialize(sym, state)
        @symbol = sym.to_sym
        @state  = state
      end

      attr_reader :symbol
      attr_reader :state

      def ==(other)
        if !other.respond_to?(:symbol) || !other.respond_to?(:state)
          false
        else
          symbol == other.symbol
        end
      end

      def matches?(str)
        str = str[0..0]

        if str.length > 0 && @symbol == str.to_sym
          @state.matches? str[1..str.length]
        else
          false
        end
      end
    end
  end
end
