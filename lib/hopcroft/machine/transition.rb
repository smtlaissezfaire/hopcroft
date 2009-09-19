module Hopcroft
  module Machine
    class Transition
      def initialize(symbol, state)
        @symbol = symbol.respond_to?(:to_sym) ? symbol.to_sym : symbol
        @state  = state
      end

      attr_reader :symbol
      attr_reader :state
      alias_method :to, :state

      def deep_clone
        self.class.new(symbol, state.deep_clone)
      end
      
      def epsilon_transition?
        symbol == EpsilonTransition
      end
    end
  end
end
