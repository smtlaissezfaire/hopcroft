
def load_hopcroft!
  reload!
  include Hopcroft
end

def reload!
  load "lib/hopcroft.rb"
end

load_hopcroft!
