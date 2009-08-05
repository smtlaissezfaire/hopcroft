module Hopcroft
  module Regex
    class OptionalSymbol < Base
      def to_regex_s
        "#{expression.to_regex_s}#{QUESTION}"
      end

      def build_machine(start)
        start.final_state = true
        
        machine = @expression.to_machine
        start.add_transition :machine => machine
      end
    end
  end
end
