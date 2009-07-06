module Hopcroft
  module Regex
    class Char < Base
      class InvalidInput < StandardError; end

      def initialize(str)
        raise InvalidInput if str.empty?
        @char = str
      end

      def matches?(char)
        to_machine.matches?(char)
      end

      def to_machine
        returning new_machine do |m|
          state = m.start_state
          state.add_transition(:symbol => @char, :final => true)
        end
      end
    end
  end
end
