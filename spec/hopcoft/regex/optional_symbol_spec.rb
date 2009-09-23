require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Regex
    describe OptionalSymbol do
      def new_optional_symbol(str)
        OptionalSymbol.new(Char.new(str))
      end
      
      it "should have the expression" do
        optional = new_optional_symbol("a")
        optional.expression.should == Char.new("a")
      end

      it "should have the regex" do
        optional = new_optional_symbol("a")
        optional.to_regex_s.should == "a?"
      end

      it "should use the correct expression in to_regex_s" do
        optional = new_optional_symbol("b")
        optional.to_regex_s.should == "b?"
      end

      it "should match the char if present" do
        optional = new_optional_symbol("a")
        optional.matches?("a").should be_true
      end

      it "should match an empty string" do
        optional = new_optional_symbol("a")
        optional.matches?("").should be_true
      end

      it "should not match a one char input when the char does not match" do
        optional = new_optional_symbol("a")
        optional.matches?("b").should be_false
      end

      it "should not match a two char input" do
        optional = new_optional_symbol("a")
        optional.matches?("ab").should be_false
      end
      
      it "should match the correct char" do
        optional = new_optional_symbol("b")
        optional.matches?("b").should be_true
      end
    end
  end
end
