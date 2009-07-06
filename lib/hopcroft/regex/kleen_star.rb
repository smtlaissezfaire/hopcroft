module Hopcroft
  module Regex
    class KleenStar < Base
      def matches?(str)
        to_machine.matches?(str)
      end
   
      def to_machine
        returning new_machine do |m|
          state = m.start_state
          final_state = state.add_transition :symbol => @expression, :final => true
          final_state.add_transition :symbol => @expression, :state => final_state
          state.add_transition :epsilon => true, :state => final_state
        end
      end
    end
  end
end
