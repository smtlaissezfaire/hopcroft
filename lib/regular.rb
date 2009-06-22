require "using"
require "facets/kernel/returning"

module Regular
  extend Using

  using :Regex
  using :Machine
end
