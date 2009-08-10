module Hopcroft
  module Regex
    module SyntaxNodes
      class Base < ::Treetop::Runtime::SyntaxNode; end
      
      class Subexpression < Base
        def eval
          char = leading_expression.eval.call(leading_expression)
        
          subexpr = subexpression.eval
          
          if subexpr.respond_to?(:call)
            subexpr.call(char)
          elsif subexpr
            char + subexpr
          else
            char
          end
        end
      end
      
      class ParenthesizedExpression < Base
        def eval
          regex.eval
        end
      end
      
      class Plus < Base
        def eval
          lambda do |obj|
            Hopcroft::Regex::Plus.new(obj)
          end
        end
      end
      
      class KleenStar < Base
        def eval
          lambda do |obj|
            Hopcroft::Regex::KleenStar.new(obj)
          end
        end
      end
      
      class OptionalSymbol < Base
        def eval
          lambda do |obj|
            Hopcroft::Regex::OptionalSymbol.new(obj)
          end
        end
      end
      
      class Epsilon < Base
        def eval
          # nil
        end
      end
      
      class Alternation < Base
        def eval
          lambda do |obj|
            Regex::Alternation.new(obj, regex.eval)
          end
        end
      end
      
      class Dot < Base
        def eval
          lambda do |obj|
            Regex::Dot.new
          end
        end
      end
      
      module NonSpecialChar
        def eval
          lambda do |obj|
            Char.new(obj.text_value)
          end
        end
      end
      
      class CharClass < Base
        def eval
          lambda do
            CharacterClass.new(inner_char_class.eval.call)
          end
        end
      end
      
      class TwoCharClass < Base
        def eval
          lambda do
            "#{one.text_value}-#{two.text_value}"
          end
        end
      end
      
      module OneCharCharClass
        def eval
          lambda do
            text_value
          end
        end
      end
      
      class EscapedChar < Base
        def eval
          lambda do |obj|
            Char.new(any_char.text_value)
          end
        end
      end
    end
  end
end
  