module Hopcroft
  module Regex
    class Alternation < Base
      def initialize(*expressions)
        @expressions = expressions
      end

      attr_reader :expressions

      def to_regex_s
        regexs.join ALTERNATION
      end

      def build_machine(start)
        @expressions.each do |expr|
          start.add_transition :machine => expr.to_machine
        end
      end

    private

      def regexs
        @expressions.map { |expression| expression.to_regex_s }
      end
    end
  end
end
