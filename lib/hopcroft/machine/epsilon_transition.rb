module Hopcroft
  module Machine
    class EpsilonTransition < Transition
      def initialize(to)
        super(self.class, to)
      end

      def matches?(anything)
        true
      end
    end
  end
end
