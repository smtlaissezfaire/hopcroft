module Hopcroft
  module Machine
    class TableConverter
      EMPTY_SET_SYMBOL = ""

      def initialize(hash)
        @hash = hash
      end

      def transition_symbols
        @hash.values.map { |v| v.keys }.flatten.uniq
      end

      def primary_states
        @hash.keys
      end

      def header
        if transition_symbols.any?
          ["", transition_symbols].flatten
        else
          []
        end
      end

      def body
        primary_states.map do |state|
          returning [state] do |a|
            
            transition_symbols.each do |transition|
              if val = @hash[state][transition]
                a << val
              else
                a << EMPTY_SET_SYMBOL
              end
            end
            
            a.flatten!
          end
        end
      end

      def to_a
        if @hash.empty?
          []
        else
          [header, body]
        end
      end
    end
  end
end
