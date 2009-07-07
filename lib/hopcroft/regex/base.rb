module Hopcroft
  module Regex
    class Base
      def initialize(expr)
        @expression = expr
      end
   
      attr_reader :expression
   
    private

      def new_machine
        returning Machine::StateMachine.new_with_start_state do |machine|
          yield machine if block_given?
        end
      end
    end
  end
end
