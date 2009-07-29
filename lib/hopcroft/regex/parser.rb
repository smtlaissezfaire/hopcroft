require "treetop"
Treetop.load File.dirname(__FILE__) + "/regex_parser"

module Hopcroft
  module Regex
    class Parser
      def self.parse(str)
        new.parse_and_eval(str)
      end

      def initialize
        @parser = Regex::TreetopRegexParser.new
      end

      def parse(str)
        @parser.parse(str)
      end

      def parse_and_eval(str)
        parse(str).eval
      end
    end
  end
end
