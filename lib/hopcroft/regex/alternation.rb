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

      def to_machine
        returning new_machine do |machine|
          machine.use_start_state do |start|
            @expressions.each do |expr|
              subexpression_start = expr.to_machine.start_state
              subexpression_start.start_state = false
              
              start.add_transition :state => subexpression_start, :epsilon => true
            end
          end
        end
      end

    private

      def regexs
        @expressions.map { |expression| expression.to_regex_s }
      end
    end
  end
end
