module Hopcroft
  module Machine
    class TransitionTable < Hash
      def add_state_change(symbol, to)
        self[symbol] ||= []
        self[symbol] << to
      end
    end
  end
end