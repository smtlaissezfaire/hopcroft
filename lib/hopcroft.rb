require "using"
require "facets/kernel/returning"

module Hopcroft
  extend Using

  Using.default_load_scheme = :autoload

  using :Regex
  using :Machine
  using :Converters
end
