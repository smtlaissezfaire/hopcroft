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
          entries_under_state_for_symbol(entries_for_state, transition_symbol.to_sym)
        else
          []
        end
      end

      def entries_under_state_for_symbol(state, symbol)
        returning Array.new do |a|
          a << state[symbol]
          a << state[EpsilonTransition]
          a << state[AnyCharTransition]
          a.compact!
          a.flatten!
        end
      end

      def matches?(array, next_state = start_states.first)
        if next_state
          if array.empty?
            if next_state.final?
              true
            else
              if self[next_state] && epsilons = self[next_state][EpsilonTransition]
                epsilons.any? { |e| matches?(array, e) }
              else
                false
              end
            end
          else
            entries_for(next_state, array.first).any? do |entry|
              matches?(cdr(array), entry)
            end
          end
        else
          false
        end
      end

    private

      def cdr(array)
        array[1..array.size]
      end

      # Create a transition without marking appropriate start states
      def add_raw_transition(from_state, to_state, transition_symbol)
        sym = transition_symbol.respond_to?(:to_sym) ? transition_symbol.to_sym : transition_symbol

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
