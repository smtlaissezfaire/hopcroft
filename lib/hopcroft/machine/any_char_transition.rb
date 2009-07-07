module Hopcroft
  module Machine
    class AnyCharTransition < Transition
      unless defined?(EPSILON_TRANSITION_SYMBOL)
        ANY_CHAR_TRANSITION_SYMBOL = Class.new do
          def to_sym
            self
          end
        end.new
      end

      def self.symbol
        ANY_CHAR_TRANSITION_SYMBOL
      end

      def initialize(to)
        super(ANY_CHAR_TRANSITION_SYMBOL, to)
      end
    end
  end
end
