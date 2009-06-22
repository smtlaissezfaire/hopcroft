module Regular
  module Machine
    class StateMachine
      def self.new_with_start_state
        returning new do |obj|
          obj.start_state = State.new
        end
      end

      def states
        if @start_state
          [@start_state, @start_state.substates].flatten
        else
          []
        end
      end

      def start_state=(state)
        @start_state = state
      end

      attr_reader :start_state
    end
  end
end
