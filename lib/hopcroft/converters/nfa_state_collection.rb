module Hopcroft
  module Converters
    class NfaStateCollection < Array
      class << self
        def nfa_to_dfa_states
          @nfa_to_dfa_states ||= {}
        end

        def register(obj, state)
          nfa_to_dfa_states[obj] ||= state
        end
      end

      def dfa_state
        @dfa_state ||= find_or_create_dfa_state
      end

      def find_or_create_dfa_state
        find_dfa_state || create_dfa_state
      end

      def find_dfa_state
        self.class.nfa_to_dfa_states[self]
      end

      def create_dfa_state
        returning new_dfa_state do |state|
          register(state)
        end
      end

      def new_dfa_state
        returning Machine::State.new do |state|
          state.start_state = has_start_state?
          state.final_state = has_final_state?
        end
      end

      def target_states(symbol)
        target_transitions = []

        each do |state|
          additional_transitions = state.transitions.select { |t| t.symbol == symbol }
          target_transitions.concat(additional_transitions)
        end

        target_transitions.map { |t| t.state }
      end

      def has_start_state?
        any? { |s| s.start_state? }
      end

      def has_final_state?
        any? { |s| s.final_state? }
      end

      def sort
        sort_by { |state| state.id }
      end

      def ==(other)
        sort == other.sort
      end

    private

      def register(state)
        self.class.register(self, state)
      end
    end
  end
end
