require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Regex
    describe KleenStar do
      it "should take a regex" do
        s = KleenStar.new("f")
        s.expression.should == "f"
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

      it "should match 0 chars" do
        s = KleenStar.new("a")
        s.matches?("").should be_true
      end
    end
  end
end
