module Hopcroft
  module Machine
    class TransitionTable < Hash
      def initialize
        @start_states = []
      end

      attr_reader :start_states

      def add_state_change(from_state, to_state, transition_symbol)
        add_start_state(from_state) if from_state.start_state?
        add_raw_transition(from_state, to_state, transition_symbol)
      end

      def entries_for(state, transition_symbol)
        if entries_for_state = self[state]
          entries_for_state[transition_symbol.to_sym] || []
        else
          []
        end
      end

      def matches?(array, next_state = start_states.first)
        if next_state
          if array.size == 1
            entries_for(next_state, array.first).any? { |state| state.final? }
          else
            entries = entries_for(next_state, array.first)
            entries.any? do |entry|
              matches?(array[1..array.size], entry)
            end
          end
        else
          false
        end
      end

    private

      # Create a transition without marking appropriate start states
      def add_raw_transition(from_state, to_state, transition_symbol)
        sym = transition_symbol.to_sym

        self[from_state] ||= {}
        self[from_state][sym] ||= []
        self[from_state][sym] << to_state
      end

      def add_start_state(state)
        start_states << state unless start_states.include?(state)
      end
    end
  end
end
