module Hopcroft
  module Regex
    class Char < Base
      class InvalidInput < StandardError; end

      def initialize(str)
        raise InvalidInput if str.empty?
        super
      end

      alias_method :to_regex_s, :expression

      def matches?(char)
        to_machine.matches?(char)
      end

      def to_machine
        returning new_machine do |machine|
          machine.use_start_state do |start_state|
            start_state.add_transition :symbol => expression, :final => true
          end
        end
      end
    end
  end
end
