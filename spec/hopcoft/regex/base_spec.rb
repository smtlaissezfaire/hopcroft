require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Regex
    describe Base do
      describe "==" do
        it "should be false if the other does not respond_to :to_regex_s" do
          Regex::KleenStar.new("a").should_not == Object.new
        end

        it "should be false if the other object generates a different regex" do
          Regex::KleenStar.new("a").should_not == Regex::KleenStar.new("b")
        end

        it "should be true if the other generates the same regex" do
          Regex::KleenStar.new("a").should == Regex::KleenStar.new("a")
        end
      end

      describe "+" do
        it "should produce a concatenation of two regexs" do
          one = Regex::Char.new("a")
          two = Regex::Char.new("b")
          concat = one + two

          concat.to_regex_s.should == "ab"
        end

        it "should use the correct objects" do
          one = Regex::Char.new("x")
          two = Regex::Char.new("y")

          (one + two).to_regex_s.should == "xy"
        end
      end

      describe "to_regexp" do
        it "should turn the object into a regexp" do
          Char.new("x").to_regexp.should == /x/
        end

        it "should use the self" do
          Char.new("y").to_regexp.should == /y/
        end

        it "should have #to_regex as an alias" do
          c = Char.new("a")
          c.method(:to_regex).should == c.method(:to_regexp)
        end
      end
    end
  end
end
