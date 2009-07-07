module Hopcroft
  module Regex
    class KleenStar < Base
      def matches?(str)
        to_machine.matches?(str)
      end
   
      def to_machine
        returning new_machine do |machine|
          machine.use_start_state do |state|
            state.add_transition :symbol => @expression, :final => true do |final_state|
              final_state.add_transition :symbol => @expression, :state => final_state
              state.add_transition :epsilon => true, :state => final_state
            end
          end
        end
      end

      def to_regex_s
        "#{expression}*"
      end
    end
  end
end
