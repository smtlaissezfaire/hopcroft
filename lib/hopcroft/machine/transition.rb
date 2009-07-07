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
    end
  end
end
