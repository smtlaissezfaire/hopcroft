module Hopcroft
  module Regex
    module SyntaxNodes
      class Base < ::Treetop::Runtime::SyntaxNode; end
      
      class MultiExpression < Base
        def eval
          second_expression.call(first_expression)
        end
      end
      
      class LeftFactoredExpression < MultiExpression
        def first_expression
          @first_expression ||= left_factored_expression.eval.call(left_factored_expression)
        end
        
        def second_expression
          @second_expression ||= subexpression.eval
        end
      end
      
      class ParenthesizedSubexpression < MultiExpression
        def first_expression
          @first_expression ||= regex.eval
        end
        
        def second_expression
          @second_expression ||= subexpression.eval
        end
      end
      
      module Concatenation
        def eval
          lambda do |obj|
            subexpressions = elements.map { |e| e.eval }.compact
            
            if subexpressions.any?
              Regex::Concatenation.new(obj, subexpressions.first.call(self))
            else
              obj
            end
          end
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
          lambda do |obj|
            obj
          end
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
            CharacterClass.new(*inner_char_class.eval.call)
          end
        end
      end
      
      class MultipleInnerCharClassExpressions < Base
        def eval
          lambda do
            elements.map { |e| e.eval.call }
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
  