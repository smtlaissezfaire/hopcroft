module Hopcroft
  module Machine
    class EpsilonTransition < Transition
      unless defined?(EPSILON_TRANSITION_SYMBOL)
        EPSILON_TRANSITION_SYMBOL = Class.new do
          def to_sym
            self
          end
        end.new
      end

      def self.symbol
        EPSILON_TRANSITION_SYMBOL
      end

      def initialize(to)
        super(EPSILON_TRANSITION_SYMBOL, to)
      end

      def matches?(anything)
        true
      end
    end
  end
end
