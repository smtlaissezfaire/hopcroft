module Hopcroft
  module Regex
    class KleenStar < Base
      def to_machine
        returning new_machine do |machine|
          machine.use_start_state do |start|
            start.final_state = true

            other_machine = @expression.to_machine
            other_start   = other_machine.start_state
            other_start.start_state = false

            start.add_transition :state => other_start, :epsilon => true
          end
        end
      end

      def to_regex_s
        "#{regex_s_for_expression(expression)}#{STAR}"
      end
    end
  end
end
