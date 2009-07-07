module Hopcroft
  module Regex
    class Char < Base
      class InvalidInput < StandardError; end

      def initialize(str)
        raise InvalidInput if str.empty?
        super
      end

      def to_regex_s
        if SPECIAL_CHARS.include?(expression)
          "#{ESCAPE_CHAR}#{expression}"
        else
          expression
        end
      end

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
