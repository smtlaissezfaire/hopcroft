module Hopcroft
  module Machine
    module StateMachineHelpers
      def epsilon_closure(state_or_state_list)
        if state_or_state_list.is_a?(Machine::State)
          epsilon_closure_for_state(state_or_state_list)
        else
          epsilon_closure_for_state_list(state_or_state_list)
        end
      end

    private

      def epsilon_closure_for_state_list(state_list)
        returning [] do |return_list|
          state_list.each do |state|
            return_list.concat(epsilon_closure_for_state(state))
          end
        end
      end

      def epsilon_closure_for_state(state, seen_states = [])
        returning [] do |set|
          if !seen_states.include?(state)
            set << state
            state.epsilon_transitions.each do |transition|
              set.concat(epsilon_closure_for_state(transition.state, seen_states << state))
            end
          end
        end
      end
    end
  end
end
