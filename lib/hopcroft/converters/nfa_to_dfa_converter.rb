module Hopcroft
  module Converters
    class NfaToDfaConverter
      def initialize(nfa)
        @nfa = nfa
        @nfa_states = {}
        @nfa_to_dfa_states = {}
      end
      
      attr_reader :nfa
      
      def convert
        start_state = @nfa.start_state
        @nfa_states = { start_state => false }
        
        returning new_machine do |dfa|
          dfa.start_state = find_or_create_state(nfa.start_state)
          
          while nfa_state = unmarked_states.first
            mark_state(nfa_state)
          
            symbols.each do |sym|
              if target_nfa_state = move(nfa_state, sym)
                add_nfa_state(target_nfa_state)
                find_or_create_state(nfa_state).add_transition :symbol => sym, :state => find_or_create_state(target_nfa_state)
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
        if transition = nfa_states.transitions.detect { |t| t.symbol == symbol }
          transition.state
        else
          nil
        end
      end
      
      def find_or_create_state(nfa_states)
        find_dfa_corresponding_to_nfa_state(nfa_states) || new_dfa_state(nfa_states)
      end
      
      def find_dfa_corresponding_to_nfa_state(nfa_states)
        @nfa_to_dfa_states[nfa_states]
      end
      
      def new_dfa_state(nfa_states)
        @nfa_to_dfa_states[nfa_states] = Machine::State.new
      end
    
      def new_machine
        Machine::StateMachine.new
      end
    end
  end
end