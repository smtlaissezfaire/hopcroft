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
      
      alias_method :matched_by?, :matches?

      def +(other)
        Concatenation.new(self, other)
      end

      def |(other)
        Alternation.new(self, other)
      end

      def to_regexp
        Regexp.new(to_regex_s)
      end

      alias_method :to_regex, :to_regexp

      def regex_s_for_expression(expr)
        expression.respond_to?(:to_regex_s) ? expression.to_regex_s : expression.to_s
      end

    private

      def new_machine
        returning Machine::StateMachine.new_with_start_state do |machine|
          yield machine, machine.start_state if block_given?
        end
      end
    end
  end
end
