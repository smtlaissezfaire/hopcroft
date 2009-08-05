module Hopcroft
  module Regex
    class KleenStar < Base
      def build_machine(start)
        other_machine = @expression.to_machine

        start.final_state = true
        start.add_transition :machine => other_machine

        other_machine.final_states.each do |state|
          state.add_transition :machine => Plus.new(@expression).to_machine
        end
      end

      def to_regex_s
        "#{regex_s_for_expression(expression)}#{STAR}"
      end
    end
  end
end
