module Hopcroft
  module Regex
    class OptionalSymbol < Base
      def to_regex_s
        "#{regex_s_for_expression(expression)}#{QUESTION}"
      end

      def to_machine
        new_machine do |machine|
          machine.use_start_state do |start|
            start.final_state = true
            start.add_transition :symbol => :a, :final => true
          end
        end
      end
    end
  end
end
