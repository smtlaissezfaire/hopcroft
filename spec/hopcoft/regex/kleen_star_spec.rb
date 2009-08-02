require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Regex
    describe KleenStar do
      it "should take a regex" do
        s = KleenStar.new("f")
        s.expression.should == "f"
      end

      describe "matching" do
        it "should match 0 chars" do
          s = KleenStar.new("a")
          s.matches?("").should be_true
        end

        it "should match one char" do
          s = KleenStar.new("a")
          s.matches?("a").should be_true
        end
     
        it "should match a different char" do
          s = KleenStar.new("a")
          s.matches?("b").should be_true
        end
   
        it "should match many of the same chars" do
          s = KleenStar.new("a")
          s.matches?("aa").should be_true
        end
      end
   
      it "should have the regex string" do
        KleenStar.new("a").to_regex_s.should == "a*"
      end

      it "should be able to output the state table" do
        star = KleenStar.new("a")
        
        lambda {
          star.to_machine.state_table.inspect
        }.should_not raise_error
      end

      describe "==" do
        it "should be true with subexpressions" do
          one = KleenStar.new(CharacterClass.new("a-z"))
          two = KleenStar.new(CharacterClass.new("a-z"))

          one.should == two
          two.should == one
        end
      end
    end
  end
end
