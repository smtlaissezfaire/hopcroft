module Hopcroft
  module Converters
    class NfaToDfaConverter
      include Machine::StateMachineHelpers

      def initialize(nfa)
        @nfa = nfa
        @nfa_states = {}
      end

      attr_reader :nfa

      def convert
        start_state = [@nfa.start_state]
        @nfa_states = { start_state => false }

        returning Machine::StateMachine.new do |dfa|
          dfa.start_state = dfa_state_for(start_state)

          while nfa_state = unmarked_states.first
            mark_state(nfa_state)

            symbols.each do |sym|
              target_nfa_states = move(epsilon_closure(nfa_state), sym)

              if target_nfa_states.any?
                add_nfa_state(target_nfa_states)

                source = dfa_state_for(nfa_state)
                target = dfa_state_for(target_nfa_states)
                source.add_transition :symbol => sym, :state => target
              end
            end
          end
        end
      end

    private

      def unmarked_states
        returning [] do |array|
          @nfa_states.each do |nfa_state, marked|
            if !marked
              array << nfa_state
            end
          end
        end
      end

      def add_nfa_state(nfa_state)
        if !@nfa_states.has_key?(nfa_state)
          @nfa_states[nfa_state] = false
        end
      end

      def mark_state(nfa_state)
        @nfa_states[nfa_state] = true
      end

      def symbols
        @symbols ||= @nfa.symbols
      end

      def move(nfa_states, symbol)
        to_collection(nfa_states).target_states(symbol)
      end

      def to_collection(nfa_states)
        if nfa_states.respond_to? :target_states
          nfa_states
        else
          NfaStateCollection.new(nfa_states)
        end
      end

      def dfa_state_for(nfa_states)
        to_collection(nfa_states).dfa_state
      end
    end
  end
end
