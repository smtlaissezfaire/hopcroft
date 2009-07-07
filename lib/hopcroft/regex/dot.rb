module Hopcroft
  module Regex
    class Dot < Base
      def initialize; end

      def matches?(str)
        to_machine.matches?(str)
      end

      def to_machine
        new_machine do |machine|
          machine.use_start_state do |start|
            start.add_transition :any => true, :final => true
          end
        end
      end
    end
  end
end
