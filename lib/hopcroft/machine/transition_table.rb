module Hopcroft
  module Machine
    class TransitionTable < Hash
      class MissingStartState < StandardError; end
      
      attr_reader :start_state

      def start_state=(start_state)
        self[start_state] ||= {}
        @start_state = start_state
      end

      # Create a transition without marking appropriate start states
      def add_state_change(from_state, to_state, transition_symbol)
        sym = transition_symbol

        self[from_state]      ||= {}
        self[from_state][sym] ||= []
        self[from_state][sym] << to_state
      end

      def has_state_change?(from_state, to_state, transition_symbol)
        self[from_state] &&
          self[from_state][transition_symbol] &&
          self[from_state][transition_symbol].include?(to_state)
      end

      def targets_for(state, transition_sym)
        find_targets_matching(state, transition_sym) do |target|
          epsilon_states_following(target)
        end
      end

      def initial_states
        [start_state] + epsilon_states_following(start_state)
      end

      def next_transitions(states, sym)
        states.map { |s| targets_for(s, sym) }.compact.flatten
      end

      def matches?(input_array, current_states = initial_states)
        raise MissingStartState unless start_state

        input_array.each do |sym|
          current_states = next_transitions(current_states, sym.to_sym)
        end

        current_states.any? { |state| state.final? }
      end

      def inspect
        TableDisplayer.new(self).to_s
      end

      def to_hash
        Hash.new(self)
      end

    private

      def epsilon_states_following(state)
        find_targets_matching(state, EpsilonTransition) do |target|
          epsilon_states_following(target)
        end
      end
      
      def find_targets_matching(state, transition_sym, &recursion_block)
        returning Array.new do |a|
          direct_targets = find_targets_for(state, transition_sym)
          append a, direct_targets
        
          direct_targets.each do |target|
            append a, recursion_block.call(target)
          end
        end
      end
      
      def find_targets_for(state, transition_sym)
        returning Array.new do |a|
          if state = self[state]
            if state[transition_sym]
              append a, state[transition_sym]
            end

            if state[AnyCharTransition] && transition_sym != EpsilonTransition
              append a, state[AnyCharTransition]
            end
          end
        end
      end
      
      def append(array1, array2)
        array1.push *array2
      end
    end
  end
end
