module Hopcroft
  module Regex
    class KleenStar < Base
      def initialize(expr)
        @expression = expr
      end
   
      attr_reader :expression
   
      def matches?(str)
        to_machine.matches?(str)
      end
   
      def to_machine
        returning new_machine do |m|
          state = m.start_state
          state.final_state = true
          state.add_transition(@expression, :final => true)
        end
      end
    end
  end
end
