module Hopcroft
  module Machine
    class StateMachine
      def self.new_with_start_state
        returning new do |obj|
          obj.build_start_state
        end
      end

      def states
        if @start_state
          [@start_state, @start_state.substates].flatten
        else
          []
        end
      end

      attr_accessor :start_state

      def build_start_state
        self.start_state = State.new
      end

      def ==(other)
        if !other.respond_to?(:states)
          false
        else
          states == other.states
        end
      end
    end
  end
end
