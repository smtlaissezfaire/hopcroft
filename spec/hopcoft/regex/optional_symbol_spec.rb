require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Regex
    describe OptionalSymbol do
      it "should have the expression" do
        optional = OptionalSymbol.new("a")
        optional.expression.should == "a"
      end

      it "should have the regex" do
        optional = OptionalSymbol.new("a")
        optional.to_regex_s.should == "a?"
      end

      it "should use the correct expression in to_regex_s" do
        optional = OptionalSymbol.new("b")
        optional.to_regex_s.should == "b?"
      end

      it "should match the char if present" do
        optional = OptionalSymbol.new("a")
        optional.matches?("a").should be_true
      end

      it "should match an empty string" do
        optional = OptionalSymbol.new("a")
        optional.matches?("").should be_true
      end

      it "should not match a one char input when the char does not match" do
        optional = OptionalSymbol.new("a")
        optional.matches?("b").should be_false
      end

      it "should not match a two char input" do
        optional = OptionalSymbol.new("a")
        optional.matches?("ab").should be_false
      end
    end
  end
end
