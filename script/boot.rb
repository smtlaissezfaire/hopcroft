
def load_hopcroft!
  require "rubygems"
  reload!
  include Hopcroft
end

def reload!
  load "lib/hopcroft.rb"
end

load_hopcroft!
