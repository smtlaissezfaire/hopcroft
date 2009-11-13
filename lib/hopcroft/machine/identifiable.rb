module Hopcroft
  module Machine
    module Identifiable
      class << self
        def extended(mod)
          mod.extend ClassMethods
          mod.class_eval do
            include InstanceMethods
          end
        end

        alias_method :included, :extended
      end

      module ClassMethods
        def reset_counter!
          @counter = 1
        end

        def next_counter
          returning counter do |c|
            @counter += 1
          end
        end

        def counter
          @counter ||= 1
        end
      end

      module InstanceMethods
        def track_id
          @id = self.class.next_counter
        end

        attr_reader :id
      end
    end
  end
end
