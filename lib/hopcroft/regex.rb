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

    using :Parser
  end
end
