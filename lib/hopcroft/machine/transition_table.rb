module Hopcroft
  module Machine
    class TransitionTable < Hash
      class MissingStartState < StandardError; end
      
      attr_accessor :start_state
      
      # def add_state_change(from, to, sym)
      #   self[from]      ||= {}
      #   self[from][sym]   = to
      # end
      # 
      def has_state_change?(from, to, sym)
        self[from] && self[from][sym]
      end
      
      def to_hash
        Hash.new(self)
      end
      
      def inspect
        TableDisplayer.new(self).to_s
      end
      
      # def matches?(*args)
      #   raise NotImplementedError
      # end
      # 
      def matched_by?(*args)
        matches?(*args)
      end
      
    private
    
      def raise_if_no_start_state
        raise MissingStartState unless start_state
      end    
    end
  end
end