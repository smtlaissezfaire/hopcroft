module Hopcroft
  module Regex
    class Plus < Base
      def build_machine(start_state)
        subexpression = @expression.to_machine

        start_state.add_transition :machine => subexpression

        subexpression.final_states.each do |state|
          state.add_transition :machine => KleenStar.new(@expression).to_machine
        end
      end

      def to_regex_s
        "#{regex_s_for_expression(expression)}#{PLUS}"
      end
    end
  end
end
