module Hopcroft
  module Regex
    module SyntaxNodes
      class Base < ::Treetop::Runtime::SyntaxNode; end
      
      class Regex < Base
        def eval
          if tuple = regex_prime.eval
            tuple.first.new(branch.eval, tuple.last)
          else
            branch.eval
          end
        end
      end
      
      module Char
        def eval
          Hopcroft::Regex::Char.new(text_value)
        end
      end
      
      class Branch < Base
        def eval
          if branch_prime.eval
            closure.eval + branch_prime.eval
          else
            closure.eval
          end
        end
      end
      
      class Alternation < Base
        def eval
          if sub = subexpression.eval
            subexpression = sub.first.new(branch.eval, sub.last)
            [Hopcroft::Regex::Alternation, subexpression]
          else
            [Hopcroft::Regex::Alternation, branch.eval]
          end
        end
      end

      class Concatenation < Base
        def eval
          if other = branch_prime.eval
            closure.eval + branch_prime.eval
          else
            closure.eval
          end
        end
      end
      
      class Closure < Base
        def eval
          if closure_prime.eval
            closure_prime.eval.new(atom.eval)
          else
            atom.eval
          end
        end
      end
      
      class KleenStar < Base
        def eval
          Hopcroft::Regex::KleenStar
        end
      end
      
      class OptionalExpression < Base
        def eval
          Hopcroft::Regex::OptionalSymbol
        end
      end
      
      class OneOrMoreExpression < Base
        def eval
          Hopcroft::Regex::Plus
        end
      end
      
      class CharacterClass < Base
        def eval
          Hopcroft::Regex::CharacterClass.new(*inner_char_class.eval)
        end
      end
      
      class MultipleInnerCharClass < Base
        def eval
          elements.map { |e| e.eval }
        end
      end
      
      class TwoCharClass < Base
        def eval
          "#{one.text_value}-#{two.text_value}"
        end
      end
      
      module OneCharClass
        def eval
          text_value
        end
      end
      
      class Epsilon < Base
        def eval
          nil
        end
      end
      
      class ParenthesizedExpression < Base
        def eval
          regex.eval
        end
      end
      
      class Dot < Base
        def eval
          Hopcroft::Regex::Dot.new
        end
      end
    end
  end
end
  
