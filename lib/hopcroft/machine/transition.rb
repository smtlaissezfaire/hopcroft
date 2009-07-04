module Hopcroft
  module Machine
    class Transition
      def initialize(sym_or_proc, state)
        @symbol = sym_or_proc.respond_to?(:call) ? sym_or_proc : sym_or_proc.to_sym
        @state  = state
      end

      attr_reader :symbol
      attr_reader :state
      alias_method :to, :state

      def ==(other)
        if !other.respond_to?(:symbol) || !other.respond_to?(:state)
          false
        else
          symbol == other.symbol
        end
      end

      def matches?(str)
        str = str[0..0]

        if str.length > 0 && matches_proc?(str)
          @state.matches? str[1..str.length]
        else
          false
        end
      end

      def matches_proc?(str)
        if @symbol.respond_to?(:call)
          @symbol.call(str)
        else
          @symbol == str.to_sym
        end
      end
    end
  end
end
