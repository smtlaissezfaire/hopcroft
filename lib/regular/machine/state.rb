module Regular
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
    end
  end
end
