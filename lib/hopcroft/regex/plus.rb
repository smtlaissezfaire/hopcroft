module Hopcroft
  module Regex
    class Plus < Base
      def matches?(str)
        to_machine.matches?(str)
      end

      def to_machine
        new_machine do |m|
          state = m.start_state
          state.add_transition(expression, :final => true)
        end
      end
    end
  end
end
