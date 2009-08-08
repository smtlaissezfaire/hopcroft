module Hopcroft
  module Machine
    class TransitionTable < Hash
      class MissingStartState < StandardError; end
      
      attr_accessor :start_state
      
      def add_state_change(from, to, sym)
        self[from]      ||= {}
        self[from][sym]   = to
      end
      
      def has_state_change?(from, to, sym)
        self[from] && self[from][sym]
      end
      
      def matches?(input_array, current_states = initial_states)
        raise MissingStartState unless start_state

        input_array.each do |sym|
          current_states = next_transitions(current_states, sym.to_sym)
        end

        current_states.any? { |state| state.final? }
      end
      
      def to_hash
        Hash.new(self)
      end
      
      def inspect
        TableDisplayer.new(self).to_s
      end
    end
  end
end