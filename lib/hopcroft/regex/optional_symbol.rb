module Hopcroft
  module Regex
    class OptionalSymbol < Base
      def to_regex_s
        "#{regex_s_for_expression(expression)}#{QUESTION}"
      end

      def build_machine(start)
        start.final_state = true
        start.add_transition :symbol => @expression, :final => true
      end
    end
  end
end
