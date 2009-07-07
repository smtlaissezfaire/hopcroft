module Hopcroft
  module Regex
    class Plus < Base
      def matches?(str)
        to_machine.matches?(str)
      end

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
        "#{expression}#{PLUS}"
      end
    end
  end
end
