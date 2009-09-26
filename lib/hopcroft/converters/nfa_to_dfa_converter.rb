module Hopcroft
  module Converters
    class NfaToDfaConverter
      include Machine::StateMachineHelpers
      
      def initialize(nfa)
        @nfa = nfa
        @nfa_states = {}
        @nfa_to_dfa_states = {}
      end
      
      attr_reader :nfa
      
      def convert
        start_state = [@nfa.start_state]
        @nfa_states = { start_state => false }
        
        returning new_machine do |dfa|
          dfa.start_state = find_or_create_state(start_state)
          
          while nfa_state = unmarked_states.first
            mark_state(nfa_state)

            symbols.each do |sym|
              target_nfa_states = move(epsilon_closure(nfa_state), sym)
              
              if target_nfa_states.any?
                add_nfa_state(target_nfa_states)
                find_or_create_state(nfa_state).add_transition :symbol => sym, :state => find_or_create_target_state(target_nfa_states)
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
        @nfa.symbols
      end
    
      def move(nfa_states, symbol)
        target_transitions = []
        
        nfa_states.each do |state|
          additional_transitions = state.transitions.select { |t| t.symbol == symbol }
          target_transitions.concat(additional_transitions)
        end
        
        target_transitions.map { |t| t.state }
      end
      
      def find_or_create_state(nfa_states)
        nfa_states = ordered_nfa_states(nfa_states)
        find_dfa_corresponding_to_nfa_state(nfa_states) || new_dfa_state(nfa_states)
      end
      
      def find_or_create_target_state(nfa_states)
        returning find_or_create_state(nfa_states) do |state|
          state.final_state = true if any_final?(nfa_states)
        end
      end
      
      def any_final?(states)
        states.any? { |s| s.final_state? }
      end
      
      def find_dfa_corresponding_to_nfa_state(nfa_states)
        @nfa_to_dfa_states[nfa_states]
      end
      
      def new_dfa_state(nfa_states)
        @nfa_to_dfa_states[nfa_states] = Machine::State.new
      end
      
      def ordered_nfa_states(nfa_states)
        nfa_states.sort_by { |state| state.id }
      end
    
      def new_machine
        Machine::StateMachine.new
      end
    end
  end
end