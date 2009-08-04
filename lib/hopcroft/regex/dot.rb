module Hopcroft
  module Regex
    class Dot < Base
      def initialize; end

      def to_machine
        new_machine do |machine, start|
          start.add_transition :any => true, :final => true
        end
      end

      def to_regex_s
        DOT
      end
    end
  end
end
