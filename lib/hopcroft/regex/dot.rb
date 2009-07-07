module Hopcroft
  module Regex
    class Dot < Base
      def initialize; end

      def to_machine
        new_machine do |machine|
          machine.use_start_state do |start|
            start.add_transition :any => true, :final => true
          end
        end
      end

      def to_regex_s
        DOT
      end
    end
  end
end
