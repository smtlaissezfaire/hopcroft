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

      def to_nfa
        new_machine do |m, start_state|
          build_machine(start_state)
        end
      end

      def to_dfa
        to_nfa.to_dfa
      end

      def to_machine
        to_nfa
      end

      def compile
        @dfa ||= to_dfa
      end

    private

      def new_machine
        returning Machine::StateMachine.new do |machine|
          yield machine, machine.start_state if block_given?
        end
      end
    end
  end
end
