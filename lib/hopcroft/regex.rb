require "treetop"

module Hopcroft
  module Regex
    SPECIAL_CHARS = [
      DOT           = ".",
      PLUS          = "+",
      QUESTION      = "?",
      STAR          = "*",
      OPEN_BRACKET  = "[",
      CLOSE_BRACKET = "]",
      ESCAPE_CHAR   = "\\",
      ALTERNATION   = "|"
    ]

    extend Using

    using :Base
    using :Char
    using :KleenStar
    using :Plus
    using :Dot
    using :CharacterClass
    using :OptionalSymbol
    using :Concatenation
    using :Alternation
    using :SyntaxNodes
    using :Parser
    
    def self.parse(from_string)
      Parser.parse(from_string)
    end
    
    def self.compile(string)
      returning parse(string) do |regex|
        regex.compile
      end
    end
  end
end
