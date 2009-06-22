module Regular
  module Machine
    class StateMachine
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
    end
  end
end
