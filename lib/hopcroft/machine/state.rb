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

      # Accepts the following hash arguments:
      #
      #   :start_state => true | false. Make the state a start state.  Defaults to false
      #   :final       => true | false. Make the state a final state.  Defaults to false
      #   :state       => a_state (if none passed, a new one is constructed)
      #   :symbol      => Symbol to transition to.
      #   :epsilon     => An Epsilon Transition instead of a regular symbol transition
      #   :any         => An any symbol transition.  Equivalent to a regex '.'
      #
      def add_transition(args={})
        args[:start_state] = false unless args.has_key?(:start_state)
        state = args[:state] ||= State.new(args)


        transitions << transition_for(args, state)
        
        yield(state) if block_given?
        state
      end

      def transition_for(args, state)
        if args[:epsilon]
          EpsilonTransition.new(state)
        elsif args[:any]
          AnyCharTransition.new(state)
        else
          Transition.new(args[:symbol], state)
        end
      end

      def start_state?
        @start_state.equal?(false) ? false : true
      end
      
      attr_writer :start_state
      
      def final_state?
        @final_state ? true : false
      end

      alias_method :final?, :final_state?

      attr_writer :final_state

      def substates
        transitions.map { |t| t.state }
      end

      def matches?(str)
        return true if final_state?
        transitions.any? { |t| t.matches?(str) }
      end

      def add_transitions_to_table(table)
        transitions.each do |transition|
          table.add_state_change(self, transition.to, transition.symbol)
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
