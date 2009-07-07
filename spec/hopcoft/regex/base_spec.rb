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
    end
  end
end
