module Regular
  module Regex
    class Char
      class InvalidInput < StandardError; end

      def initialize(str)
        raise InvalidInput if str.empty?
        @char = str
      end

      def matches?(char)
        to_machine == Char.new(char).to_machine
      end

      def to_machine
        returning new_machine do |m|
          state = m.start_state
          state.add_transition(@char, :final => true)
        end
      end

    private

      def new_machine
        Machine::StateMachine.new_with_start_state
      end
    end
  end
end
