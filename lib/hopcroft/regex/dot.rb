module Hopcroft
  module Regex
    class Dot < Base
      def initialize; end

      def build_machine(start)
        start.add_transition :any => true, :final => true
      end

      def to_regex_s
        DOT
      end
    end
  end
end
