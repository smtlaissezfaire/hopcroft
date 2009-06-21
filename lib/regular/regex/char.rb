module Regular
  module Regex
    class Char
      class InvalidInput < StandardError; end

      def initialize(str)
        raise InvalidInput if str.empty?
        @char = str
      end

      def matches?(char)
        @char == char
      end
    end
  end
end
