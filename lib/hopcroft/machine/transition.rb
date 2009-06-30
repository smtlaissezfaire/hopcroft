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
    end
  end
end
