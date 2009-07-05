module Hopcroft
  module Machine
    class StateMachine
      def self.new_with_start_state
        returning new do |obj|
          obj.build_start_state
        end
      end

      def initialize
        @start_states = []
      end

      attr_reader :start_states

      def start_state
        start_states.first
      end

      def states
        if start_states.any?
          [start_states, start_states.map { |state| state.substates }].flatten
        else
          []
        end
      end

      def build_start_state(state = State.new)
        self.start_states << state
        state
      end

      def ==(other)
        if !other.respond_to?(:states)
          false
        else
          states == other.states
        end
      end

      def matches_string?(str)
        matches_array? str.split(//)
      end
      
      def matches?(str)
        start_states.any? { |state| state.matches? str }
      end
      
      def matches_array?(array)
        state_table.matches?(array)
      end

      def state_table
        returning TransitionTable.new do |table|
          start_states.each do |state|
            state.add_transitions_to_table(table)
          end
        end
      end
    end
  end
end
