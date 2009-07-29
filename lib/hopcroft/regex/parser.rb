require "treetop"
Treetop.load File.dirname(__FILE__) + "/regex_parser"

module Hopcroft
  module Regex
    class Parser
      class ParseError < StandardError; end

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
        if parse = parse(str)
          parse.eval
        else
          raise ParseError, "could not parse the regex '#{str}'"
        end
      end
    end
  end
end
