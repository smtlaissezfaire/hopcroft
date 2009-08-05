module Hopcroft
  module Regex
    class KleenStar < Base
      def build_machine(start)
        other_machine = @expression.to_machine

        start.final_state = true
        start.add_transition :machine => other_machine

        other_machine.final_states.each do |state|
          state.add_transition :state => start, :epsilon => true
        end
      end

      def to_regex_s
        "#{expression.to_regex_s}#{STAR}"
      end
    end
  end
end
