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

      def to_machine
        new_machine do |machine, start_state|
          start_state.add_transition :symbol => expression, :final => true
        end
      end
    end
  end
end
