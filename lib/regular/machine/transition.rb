module Regular
  module Machine
    class Transition
      def initialize(sym, state)
        @symbol = sym.to_sym
        @state  = state
      end

      attr_reader :symbol
      attr_reader :state
    end
  end
end
