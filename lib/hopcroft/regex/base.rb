module Hopcroft
  module Regex
    class Base
      def initialize(expr)
        @expression = expr
      end
   
      attr_reader :expression

      def ==(other)
        other.respond_to?(:to_regex_s) &&
          to_regex_s == other.to_regex_s
      end

      def matches?(str)
        to_machine.matches? str
      end
      
    private

      def new_machine
        returning Machine::StateMachine.new_with_start_state do |machine|
          yield machine if block_given?
        end
      end
    end
  end
end
