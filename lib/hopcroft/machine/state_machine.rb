module Hopcroft
  module Machine
    class StateMachine
      def initialize(start_state = State.new)
        @start_state = start_state
      end

      attr_accessor :start_state

      def states
        [start_state, start_state.substates].flatten
      end

      def final_states
        states.select { |s| s.final? }
      end

      def matches_string?(str)
        matches_array? str.split("")
      end
      
      alias_method :matches?, :matches_string?
      
      def matches_array?(array)
        state_table.matches?(array)
      end

      def nfa_state_table
        returning NfaTransitionTable.new do |table|
          table.start_state = start_state
          start_state.add_transitions_to_table(table)
        end
      end

      alias_method :state_table, :nfa_state_table

      def deep_clone
        returning clone do |c|
          c.start_state = c.start_state.deep_clone
        end
      end
      
      def symbols
        state_table.symbols
      end
      
      def to_dfa
        Converters::NfaToDfaConverter.new(self).convert
      end
    end
  end
end
