require 'enumerator'

module Hopcroft
  module Regex
    class Concatenation < Base
      def initialize(*objs)
        @array = objs
      end

      def to_regex_s
        @array.map { |a| a.to_regex_s }.join("")
      end

      def to_a
        @array
      end

      def to_machine
        machines = components.dup

        machines.each_cons(2) do |first, second|
          first.final_states.each do |state|
            state.add_transition :state => second.start_state, :epsilon => true
            state.final_state = false
          end
        end

        machines.first
      end

    private

      def components
        @array.map { |a| a.to_machine }
      end
    end
  end
end
