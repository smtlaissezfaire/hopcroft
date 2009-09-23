require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Regex
    describe Alternation do
      describe "to_regex_s" do
        it "should be a|b" do
          one = Char.new("a")
          two = Char.new("b")
          
          alternation = Alternation.new(one, two)
          alternation.to_regex_s.should == "a|b"
        end

        it "should use the correct subexpressions" do
          one = Char.new("x")
          two = Char.new("y")
          
          alternation = Alternation.new(one, two)
          alternation.to_regex_s.should == "x|y"
        end

        it "should use more than two subexpressions" do
          one   = Char.new "a"
          two   = Char.new "b"
          three = Char.new "c"

          alternation = Alternation.new(one, two, three)

          alternation.to_regex_s.should == "a|b|c"
        end
      end

      describe "matching a string" do
        it "should match a with 'a|b'" do
          alternation = Alternation.new(Char.new("a"), Char.new("b"))

          alternation.matches?("a").should be_true
        end

        it "should not match a char not present" do
          alternation = Alternation.new(Char.new("a"), Char.new("b"))
          alternation.matches?("x").should be_false
        end

        it "should match 'b' with 'a|b'" do
          alternation = Alternation.new(Char.new("a"), Char.new("b"))

          alternation.matches?("b").should be_true
        end

        it "should not match 'ab' with 'a|b'" do
          alternation = Alternation.new(Char.new("a"), Char.new("b"))
          alternation.matches?("ab").should be_false
        end
      end

      describe "displaying the state table" do
        it "should not raise an error" do
          lambda {
            alternation = Alternation.new(Char.new("a"), Char.new("b"))
            alternation.inspect
          }.should_not raise_error
        end

        it "should keep the same number of states after being called several times" do
          alternation = Alternation.new(Char.new("a"), Char.new("b"))
          table = alternation.to_machine.state_table
          
          lambda {
            3.times do
              table.initial_states
            end
          }.should_not change { table.initial_states.size }
        end
      end
    end
  end
end
