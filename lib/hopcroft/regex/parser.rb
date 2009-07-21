module Hopcroft
  module Regex
    class Parser
      def self.parse(str)
        obj = new
        obj.parse(str)
        obj.parse_results
      end

      def initialize
        @parse_results = []
        @escaped = false
        @character_class = false
        @buffer = ""
      end

      def parse_results
        @parse_results.inject { |accumulator, obj| accumulator + obj }
      end

      attr_reader :char

      def parse(str)
        @chars = str.split("")

        @chars.each_with_index do |char, index|
          @char  = char
          @index = index

          if char == ESCAPE_CHAR
            @escaped = true
          elsif escaped?
            add_char_result(char)
          else
            non_escaped_char
          end
        end
      end

      def non_escaped_char
        if char    == OPEN_BRACKET
          @character_class = true
        elsif char == CLOSE_BRACKET && in_char_class?
          add_result CharacterClass.new(@buffer)
          reset_buffer
          @character_class = false
        elsif in_char_class?
          buffer char
          
        elsif char      == STAR
        elsif next_char == STAR
          add_result KleenStar.new(char)

        elsif char      == DOT
          add_result Dot.new

        elsif char      == QUESTION
        elsif next_char == QUESTION
          add_result OptionalSymbol.new(char)

        elsif char      == PLUS
        elsif next_char == PLUS
          add_result Plus.new(char)

        else
          add_char_result(char)
        end
      end

    private

      def reset_buffer
        @buffer = ""
      end

      def add_char_result(char)
        add_result Char.new(char)
        @escaped = false
      end

      def in_char_class?
        @character_class
      end

      def buffer(char)
        @buffer << char
      end

      def escaped?
        @escaped ? true : false
      end

      def add_result(result)
        @parse_results << result
      end

      def next_char
        @chars[@index + 1]
      end

      def peek(chars, index)
        chars[index + 1]
      end
    end
  end
end
