module Hopcroft
  module Machine
    class State
      include Identifiable

      def initialize(options={})
        track_id
        
        @start_state = options[:start_state] if options.has_key?(:start_state)
        @final_state = options[:final]       if options.has_key?(:final)
        
        assign_name(options)
      end

      attr_reader  :name
      alias_method :to_s, :name

      def inspect
        "#{name} {start: #{start_state?}, final: #{final_state?}, transitions: #{transitions.size}}"
      end

      def transitions
        @transitions ||= []
      end

      attr_writer :transitions
      
      def epsilon_transitions
        transitions.select { |t| t.epsilon_transition? }
      end
      
      def number_of_transitions
        transitions.size
      end

      # Accepts the following hash arguments:
      #
      #   :machine     => m (optional).  Links current state to start state of machine
      #                   given with an epsilon transition.
      #   :start_state => true | false. Make the state a start state.  Defaults to false
      #   :final       => true | false. Make the state a final state.  Defaults to false
      #   :state       => a_state (if none passed, a new one is constructed)
      #   :symbol      => Symbol to transition to.
      #   :epsilon     => An Epsilon Transition instead of a regular symbol transition
      #   :any         => An any symbol transition.  Equivalent to a regex '.'
      #
      def add_transition(args={})
        args[:start_state] = false unless args.has_key?(:start_state)

        if args[:machine]
          machine = args[:machine]

          args[:state] = machine.start_state
          args[:state].start_state = false
          args[:epsilon] = true
        else
          args[:state] ||= State.new(args)
        end
        
        returning args[:state] do |state|
          transitions << transition_for(args, state)
          yield(state) if block_given?
          state
        end
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
      
      def substates(excluded_states = [])
        returning [] do |list|
          follow_states.each do |state|
            unless excluded_states.include?(state)
              excluded_states << state
              
              list.push state
              list.concat(state.substates(excluded_states))
            end
          end
        end
      end
      
      def follow_states(excluded_states = [])
        transitions.map { |t| t.state }.reject { |s| excluded_states.include?(s) }
      end

      def add_transitions_to_table(table)
        transitions.each do |transition|
          to = transition.to

          unless table.has_state_change?(self, to, transition.symbol)
            table.add_state_change(self, to, transition.symbol)
            transition.to.add_transitions_to_table(table)
          end
        end
      end

      def deep_clone
        returning clone do |c|
          c.transitions = transitions.map { |t| t.deep_clone }
        end
      end

    private

      def assign_name(options)
        @name = options[:name] ? options[:name] : "State #{@id}"
      end
    end
  end
end
