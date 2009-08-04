module Hopcroft
  module Machine
    class StateMachine
      def initialize(start_state = State.new)
        @start_state = start_state
      end

      attr_accessor :start_state

      def states
        if start_state
          [start_state, start_state.substates].flatten
        else
          []
        end
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

      def state_table
        returning TransitionTable.new do |table|
          if start_state
            table.start_state = start_state
            start_state.add_transitions_to_table(table)
          end
        end
      end
    end
  end
end
