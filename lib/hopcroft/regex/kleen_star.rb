module Hopcroft
  module Regex
    class KleenStar < Base
      def to_machine
        new_machine do |machine, start|
          start.final_state = true

          other_machine = @expression.to_machine
          other_start   = other_machine.start_state
          other_start.start_state = false

          start.add_transition :state => other_start, :epsilon => true

          other_machine.final_states.each do |state|
            state.add_transition :state => Plus.new(@expression).to_machine.start_state,
                                 :epsilon => true
          end
        end
      end

      def to_regex_s
        "#{regex_s_for_expression(expression)}#{STAR}"
      end
    end
  end
end
