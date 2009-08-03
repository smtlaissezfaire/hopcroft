module Hopcroft
  module Regex
    class Plus < Base
      def to_machine
        new_machine do |machine|
          machine.use_start_state do |start_state|
            subexpression = @expression.to_machine
            subexpression_start_state = subexpression.start_state
            subexpression_start_state.start_state = false

            start_state.add_transition :state => subexpression_start_state, :epsilon => true
          end
        end
      end

      def to_regex_s
        "#{regex_s_for_expression(expression)}#{PLUS}"
      end
    end
  end
end
