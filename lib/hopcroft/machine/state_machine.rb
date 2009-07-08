module Hopcroft
  module Machine
    class StateMachine
      def self.new_with_start_state
        returning new do |obj|
          obj.build_start_state
        end
      end

      attr_reader :start_state

      def use_start_state
        if start_state
          yield start_state
        end
      end

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

      def build_start_state(state = State.new)
        returning state do |s|
          @start_state  = s
        end
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
            start_state.add_transitions_to_table(table)
          end
        end
      end
    end
  end
end
