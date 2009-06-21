require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Regular
  module Regex
    describe Char do
      it "should match one char" do
        c = Char.new("a")
        c.matches?("a").should be_true
      end

      it "should not match a different char" do
        c = Char.new("a")
        c.matches?("b").should be_false
      end

      it "should not match multiple chars" do
        c = Char.new("a")
        c.matches?("ab").should be_false
      end

      it "should raise an error if constructed with the empty string" do
        lambda { 
          Char.new("")
        }.should raise_error
      end
    end
  end
end
