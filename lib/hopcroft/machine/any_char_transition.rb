module Hopcroft
  module Machine
    class AnyCharTransition < Transition
      def initialize(to)
        super(self.class, to)
      end
    end
  end
end
