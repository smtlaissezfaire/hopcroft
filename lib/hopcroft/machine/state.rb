module Hopcroft
  module Machine
    class State
      def initialize(options={})
        self.start_state = options[:start_state] if options.has_key?(:start_state)
        self.final_state = options[:final]       if options.has_key?(:final)
      end

      def transitions
        @transitions ||= []
      end

      def add_transition(sym, options_or_state={})
        if options_or_state
          if options_or_state.is_a?(Hash)
            options = options_or_state
          else
            state = options_or_state
            state.start_state = false
          end
        end

        options ||= {}
        state   ||= State.new({:start_state => false}.merge(options))

        transitions << Transition.new(sym, state)
        state
      end

      def start_state?
        @start_state.equal?(false) ? false : true
      end

      attr_writer :start_state

      def final_state?
        @final_state ? true : false
      end

      attr_writer :final_state

      def substates
        transitions.map { |t| t.state }
      end

      def matches?(str)
        return true if final_state?
        transitions.any? { |t| t.matches?(str) }
      end

      def ==(other)
        if !other.respond_to?(:final_state?) || !other.respond_to?(:transitions)
          false
        else
          final_state? == other.final_state? && same_transitions?(other.transitions)
        end
      end
      
      def add_transitions_to_table(table)
        transitions.each do |transition|
          table.add_state_change(transition.symbol, transition.to)
          transition.to.add_transitions_to_table(table) unless transition.to == self
        end
      end

    private

      def same_transitions?(other_transitions)
        subset?(transitions, other_transitions) && subset?(other_transitions, transitions)
      end

      def subset?(t1, t2)
        t2.all? { |t| t1.include?(t) }
      end
    end
  end
end