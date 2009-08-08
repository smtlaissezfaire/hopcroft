module Hopcroft
  module Machine
    class DfaTransitionTable < TransitionTable
      class DuplicateStateError < StandardError; end
      
      def add_state_change(from, to, sym)
        self[from]      ||= {}
        raise DuplicateStateError if self[from][sym]
        self[from][sym]   = to
      end
      
      def has_state_change?(from, to, sym)
        self[from] && self[from][sym] && self[from][sym] == to ? true : false
      end
      
      def target_for(state, sym)
        self[state] && self[state][sym] ? self[state][sym] : nil
      end
      
      alias_method :initial_state,    :start_state
      alias_method :initial_states,   :start_state
      alias_method :next_transitions, :target_for
    end
  end
end
