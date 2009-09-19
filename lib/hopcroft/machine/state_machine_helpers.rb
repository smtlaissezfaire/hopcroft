module Hopcroft
  module Machine
    module StateMachineHelpers
      def epsilon_closure(state_list)
        returning [] do |return_list|
          state_list.each do |state|
            return_list.concat(epsilon_closure_for_state(state))
          end
        end
      end

    private

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
