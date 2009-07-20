module Hopcroft
  module Machine
    class TableConverter
      EMPTY_SET_SYMBOL = []

      def initialize(hash)
        @hash = hash
      end

      def transition_symbols
        @transition_symbols ||= @hash.values.map { |v| v.keys }.flatten.uniq
      end

      def primary_states
        @primary_states ||= @hash.keys.dup
      end

      def header
        transition_symbols.any? ? ["", *transition_symbols] : []
      end

      def body
        primary_states.map do |state|
          [state, *values_from(state)]
        end
      end

      def to_a
        @hash.empty? ? [] : [header, body]
      end

    private

      def values_from(state)
        transition_symbols.map do |transition|
          val = @hash[state][transition]
          val ? val : EMPTY_SET_SYMBOL
        end
      end
    end
  end
end
