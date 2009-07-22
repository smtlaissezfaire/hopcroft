module Hopcroft
  module Regex
    class Plus < Base
      def to_machine
        new_machine do |machine|
          machine.use_start_state do |start_state|
            start_state.add_transition :symbol => expression, :final => true do |final_state|
              final_state.add_transition :symbol => expression, :state => final_state
            end
          end
        end
      end

      def to_regex_s
        "#{regex_s_for_expression(expression)}#{PLUS}"
      end
    end
  end
end
