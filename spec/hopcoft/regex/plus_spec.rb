require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Regex
    describe Plus do
      it "should take a regex" do
        s = Plus.new(Char.new("f"))
        s.expression.should == Char.new("f")
      end

      describe "matching" do
        def plus_with_char(str)
          Plus.new(Char.new(str))
        end

        it "should not match an empty string" do
          s = plus_with_char("a")
          s.matches?("").should be_false
        end

        it "should match one char" do
          s = plus_with_char("a")
          s.matches?("a").should be_true
        end

        it "should not match a different char" do
          s = plus_with_char("a")
          s.matches?("b").should be_false
        end

        it "should match many of the same chars" do
          s = plus_with_char("a")
          s.matches?("aa").should be_true
        end

        it "should not match when any of the chars are different" do
          s = plus_with_char("a")
          s.matches?("aab").should be_false
        end
      end

      it "should have the regex string" do
        Plus.new(Char.new("a")).to_regex_s.should == "a+"
      end
    end
  end
end
