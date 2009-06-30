module Hopcroft
  module Regex
    class Base
      def matches?(str)
        raise NotImplementedError
      end

      def to_machine
        raise NotImplementedError
      end

    private

      def new_machine
        Machine::StateMachine.new_with_start_state
      end
    end
  end
end
