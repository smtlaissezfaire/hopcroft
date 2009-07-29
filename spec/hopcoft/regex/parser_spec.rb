require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Regex
    describe Parser do
      it "should parse 'a' as a Char" do
        Parser.parse("a").should == Char.new('a')
      end

      it "should parse 'b' as a Char" do
        Parser.parse("b").should == Char.new("b")
      end

      it "should parse 'ab' as two chars" do
        Parser.parse("ab").should == (Char.new("a") + Char.new("b"))
      end

      it "should parse a '.' as a Dot" do
        Parser.parse(".").should == Dot.new
      end

      it "should parse a '\.' as a char dot" do
        Parser.parse('\.').should == Char.new(".")
      end

      it "should parse '\..' as an escaped char + a dot" do
        Parser.parse("\\..").should == (Char.new(".") + Dot.new)
      end

      it "should parse 'a*' as a kleen star" do
        Parser.parse("a*").should == KleenStar.new("a")
      end

      it "should parse 'b*' as a kleen star" do
        Parser.parse("b*").should == KleenStar.new("b")
      end

      it "should parse '\*' as the star char" do
        Parser.parse("\\*").should == Char.new("*")
      end

      it "should parse 'a\*' as a followed by a char" do
        Parser.parse("a\\*").should == (Char.new("a") + Char.new("*"))
      end

      it "should parse a? as an optional a" do
        Parser.parse("a?").should == OptionalSymbol.new("a")
      end

      it "should parse b? as an optional b" do
        Parser.parse("b?").should == OptionalSymbol.new("b")
      end

      it "should parse an escaped question mark as a char" do
        Parser.parse("\\?").should == Char.new("?")
      end

      it "should parse a plus" do
        Parser.parse("a+").should == Plus.new("a")
      end

      it "should parse 'b+'" do
        Parser.parse("b+").should == Plus.new("b")
      end

      it "should parse an escaped plus" do
        Parser.parse("\\+").should == Char.new("+")
      end

      it "should parse [a-z] as a character class" do
        Parser.parse("[a-z]").should == CharacterClass.new("a-z")
      end

      it "should parse [b-c] as a character class" do
        Parser.parse("[b-c]").should == CharacterClass.new("b-c")
      end

      it "should parse \ as an open bracket char" do
        Parser.parse("\\[").should == Char.new("[")
      end

      it "should parse \] as a closed bracket char" do
        Parser.parse("\\]").should == Char.new("]")
      end

      it "should parse 'ab' as a concatenation of a and b" do
        char1 = Char.new("a")
        char2 = Char.new("b")

        Parser.parse("ab").should == Concatenation.new(char1, char2)
      end

      it "should parse [a-z]* as a kleen star of a char class" do
        Parser.parse("[a-z]*").should == KleenStar.new(CharacterClass.new("a-z"))
      end

      it "should parse alternation" do
        result = Parser.parse("a|b")
        result.should be_a_kind_of(Alternation)
        result.should == Alternation.new(Char.new("a"), Char.new("b"))
      end

      it "should parse correct chars in the alternation" do
        result = Parser.parse("x|y")
        result.should be_a_kind_of(Alternation)
        result.should == Alternation.new(Char.new("x"), Char.new("y"))
      end

      it "should parse '.|a' as an alternation" do
        result = Parser.parse(".|a")
        result.should be_a_kind_of(Alternation)
        result.should == Alternation.new(Dot.new, Char.new("a"))
      end

      it "should allow a char class in the second position" do
        result = Parser.parse(".|[a-z]")
        result.should be_a_kind_of(Alternation)
        result.should == Alternation.new(Dot.new, CharacterClass.new("a-z"))
        result.expressions.last.should be_a_kind_of(CharacterClass)
      end

      it "should allow a plus after a char class" do
        result = Parser.parse("[a-z]+")
        result.should be_a_kind_of(Plus)
        result.should == Plus.new(CharacterClass.new("a-z"))
      end

      it "should see an escaped plus as a char" do
        Parser.parse('\+').should be_a_kind_of(Char)
      end

      it "should see an escaped plus with a argment in front of it as an escaped plus with a concatenation" do
        result = Parser.parse('a\+')
        result.should == Concatenation.new(Char.new("a"), Char.new("+"))
      end

      it "should allow an optional char class" do
        result = Parser.parse("[a-z]?")
        result.should == OptionalSymbol.new(CharacterClass.new("a-z"))
      end

      it "should parse with parens" do
        result = Parser.parse("([a-z])")
        result.should be_a_kind_of(CharacterClass)
      end

      it "should parse an escaped paren inside parens" do
        result = Parser.parse("(\\()")
        result.should == Char.new("(")
      end

      it "should allow parens around a concatenation" do
        result = Parser.parse("(ab)")
        result.should == (Char.new("a") + Char.new("b"))
      end

      it "should parse matching escaped parens inside a set of parens" do
        result = Parser.parse '(\(\))'
        result.should == (Char.new("(") + Char.new(")"))
      end

      it "should parse two sets of parens around each other" do
        result = Parser.parse "((ab))"
        result.should == (Char.new("a") + Char.new("b"))
      end

      it "should parse a number" do
        result = Parser.parse("9")
        result.should == Char.new("9")
      end

      it "should parse any single non-special char (one that isn't in the regex set)" do
        result = Parser.parse("$")
        result.should == Char.new("$")
      end

      it "should parse an escaped or" do
        result = Parser.parse('\|')
        result.should == Char.new("|")
      end

      it "should parse an underscore" do
        result = Parser.parse("_")
        result.should == Char.new("_")
      end

      it "should parse a char class with one element" do
        result = Parser.parse("[a]")
        result.should == Char.new("a")
      end

      it "should parse an escaped special char inside a character class" do
        result = Parser.parse("[\+]")
        result.should be_a_kind_of(Char)
        result.should == Char.new("+")
      end

      it "should not parse a special char as a regular escaped char" do
        Parser.parse("[").should_not be_a_kind_of(Char)
      end

      it "should parse an empty char class" do
        result = Parser.parse("[]")
        result.should be_nil
      end

      it "should return nil if the parse is empty" do
        result = Parser.parse("")
        result.should be_nil
      end

      it "should raise an error if it cannot parse a string" do
        pending 'TODO' do
          lambda {
            Parser.parse("[")
          }.should raise_error(Parser::ParseError, "could not parse the regex '['")
        end
      end

      it "should use the correct string name" do
        pending 'TODO' do
          lambda {
            Parser.parse("]")
          }.should raise_error(Parser::ParseError, "could not parse the regex ']'")
        end
      end

      it "should allow multiple expressions inside a char class (i.e [a-zA-Z])"
    end
  end
end
