require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Regex
    describe Plus do
      it "should take a regex" do
        s = Plus.new("f")
        s.expression.should == "f"
      end
   
      it "should match one char" do
        s = Plus.new("a")
        s.matches?("a").should be_true
      end
   
      it "should not match a different char" do
        s = Plus.new("a")
        s.matches?("b").should be_false
      end

      it "should match many of the same chars" do
        s = Plus.new("a")
        s.matches?("aa").should be_true
      end

      it "should not match none of the chars" do
        s = Plus.new("a")
        s.matches?("").should be_false
      end

      it "should have the regex string" do
        Plus.new("a").to_regex_s.should == "a+"
      end
    end
  end
end
