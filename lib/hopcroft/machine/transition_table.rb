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
        sym = obj_to_sym(transition_symbol)

        self[from_state]      ||= {}
        self[from_state][sym] ||= []
        self[from_state][sym] << to_state
      end

      def has_state_change?(from_state, to_state, transition_symbol)
        self[from_state] &&
          self[from_state][transition_symbol] &&
          self[from_state][transition_symbol].include?(to_state)
      end

      def entries_for(state, given_transition_symbol)
        if entries_for_state = self[state]
          entries_under_state_for_symbol(entries_for_state, obj_to_sym(given_transition_symbol))
        else
          []
        end
      end
      
      def new_targets_for(state, transition_sym)
        append targets_for_sym(state, transition_sym),
               epsilon_targets_for_sym(state, transition_sym)
      end
      
      def targets_for_sym(state, transition_sym)
        find_targets_matching(state, transition_sym) do |target|
          epsilon_states_following(target)
        end
      end
      
      def epsilon_states_following(state)
        find_targets_matching(state, EpsilonTransition) do |target|
          epsilon_states_following(target)
        end
      end
      
      def epsilon_targets_for_sym(state, sym)
        find_targets_matching(state, EpsilonTransition) do |target|
          new_targets_for(target, sym)
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
      
      def entries_under_state_for_symbol(state, symbol)
        returning Array.new do |a|
          a.push *targets_for(state, EpsilonTransition)

          if symbol != EpsilonTransition
            a.push *targets_for(state, symbol)
            a.push *targets_for(state, AnyCharTransition)
          end
        end
      end

      def initial_states
        [start_state] + epsilon_states_following(start_state)
      end

      def next_transitions(states, sym)
        states.map { |s| entries_for(s, sym) }.compact.flatten
      end

      def matches?(input_array, current_states = initial_states)
        raise MissingStartState unless start_state

        input_array.each do |sym|
          current_states = next_transitions(current_states, sym)
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

      def targets_for(state, transition_symbol)
        if transition_symbol == EpsilonTransition && targets = state[EpsilonTransition]
          targets = targets_for_epsilon_transitions(targets)
        else
          targets = state[transition_symbol]
        end

        targets ? targets : []
      end

      def targets_for_epsilon_transitions(targets)
        returning Array.new do |a|
          a << targets
   
          targets.each do |target_state|
            target_states = transitions_and_targets(target_state)
            target_states.each do |symbol, _|
              a << targets_for(target_states, symbol)
            end
          end

          a.flatten!
        end
      end

      def transitions_and_targets(state)
        self[state] || {}
      end

      def obj_to_sym(obj)
        obj.respond_to?(:to_sym) ? obj.to_sym : obj
      end
    end
  end
end
