require "treetop"
Treetop.load File.dirname(__FILE__) + "/regex_parser"

module Hopcroft
  module Regex
    class Parser
      class ParseError < StandardError; end

      def self.parse(str, debugging = false)
        obj = new
        obj.debug = debugging
        obj.parse_and_eval(str)
      end

      def initialize
        @parser = Regex::TreetopRegexParser.new
      end

      def parse(str)
        @parser.parse(str)
      end

      def debugging?
        @debug ? true : false
      end

      attr_writer :debug

      def parse_and_eval(str)
        if parse = parse(str)
          parse.eval
        else
          puts @parser.inspect if debugging?
          raise ParseError, "could not parse the regex '#{str}'"
        end
      end
    end
  end
end
