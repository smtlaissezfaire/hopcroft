module Hopcroft
  module Regex
    class Dot < Base
      def initialize
      end

      def matches?(str)
        to_machine.matches?(str)
      end

      def to_machine
        new_machine do |m|
          state = m.start_state
          state.add_transition(lambda { |_| true }, :final => true)
        end
      end
    end
  end
end
