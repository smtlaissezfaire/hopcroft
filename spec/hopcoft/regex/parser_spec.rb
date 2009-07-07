require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Regex
    describe Parser do
      it "should have the parse as an empty array when initializing" do
        p = Parser.new
        p.parse_results.should == []
      end

      it "should parse 'a' as a Char" do
        Parser.parse("a").should == [Char.new('a')]
      end

      it "should parse 'b' as a Char" do
        Parser.parse("b").should == [Char.new("b")]
      end

      it "should parse 'ab' as two chars" do
        Parser.parse("ab").should == [Char.new("a"), Char.new("b")]
      end

      it "should parse a '.' as a Dot" do
        Parser.parse(".").should == [Dot.new]
      end

      it "should parse a '\.' as a char dot" do
        Parser.parse('\.').should == [Char.new(".")]
      end

      it "should parse '\..' as an escaped char + a dot" do
        Parser.parse("\\..").should == [Char.new("."), Dot.new]
      end

      it "should parse 'a*' as a kleen star" do
        Parser.parse("a*").should == [KleenStar.new("a")]
      end

      it "should parse '\*' as the star char" do
        Parser.parse("\\*").should == [Char.new("*")]
      end

      it "should parse 'a\*' as a followed by a char" do
        Parser.parse("a\\*").should == [Char.new("a"), Char.new("*")]
      end

      it "should parse a? as an optional a" do
        Parser.parse("a?").should == [OptionalSymbol.new("a")]
      end

      it "should parse an escaped question mark as a char" do
        Parser.parse("\\?").should == [Char.new("?")]
      end

      it "should parse a plus" do
        Parser.parse("a+").should == [Plus.new("a")]
      end

      it "should parse an escaped plus" do
        Parser.parse("\\+").should == [Char.new("+")]
      end

      it "should parse [a-z] as a character class" do
        Parser.parse("[a-z]").should == [CharacterClass.new("a-z")]
      end

      it "should parse \[ as an open bracket char" do
        Parser.parse("\\[").should == [Char.new("[")]
      end

      it "should parse \] as a closed bracket char" do
        Parser.parse("\\]").should == [Char.new("]")]
      end
    end
  end
end
