module Hopcroft
  module Machine
    class EpsilonTransition < Transition
      def initialize(to)
        super(self.class, to)
      end
    end
  end
end
