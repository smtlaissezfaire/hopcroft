module Hopcroft
  module Machine
    class Transition
      def initialize(symbol, state)
        @symbol = symbol.to_sym
        @state  = state
      end

      attr_reader :symbol
      attr_reader :state
      alias_method :to, :state

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
