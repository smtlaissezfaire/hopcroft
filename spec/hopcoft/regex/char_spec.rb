require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
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

      it "should not match an empty string" do
        c = Char.new("a")
        c.matches?("").should be_false
      end

      it "should raise an error if constructed with the empty string" do
        lambda { 
          Char.new("")
        }.should raise_error
      end

      it "should have the char as the regex" do
        Char.new("a").to_regex_s.should == "a"
        Char.new("b").to_regex_s.should == "b"
      end

      it "should escape a ." do
        Char.new(".").to_regex_s.should == '\.'
      end

      it "should escape a +" do
        Char.new("+").to_regex_s.should == '\+'
      end

      it "should escape a ?" do
        Char.new("?").to_regex_s.should == '\?'
      end

      it "should escape a *" do
        Char.new("*").to_regex_s.should == '\*'
      end

      it "should escape a [" do
        Char.new("[").to_regex_s.should == '\['
      end

      it "should escape a ]" do
        Char.new("]").to_regex_s.should == '\]'
      end
    end

    describe "to_machine" do
      it "should return a new machine" do
        char = Char.new("a")
        char.to_machine.should be_a_kind_of(Machine::StateMachine)
      end

      it "should construct the one char machine" do
        char = Char.new("a")
        start_state = char.to_machine.start_state

        start_state.transitions.size.should == 1
        first_transition = start_state.transitions.first
        first_transition.symbol.should == :a
        first_transition.state.should be_a_final_state
      end

      it "should use the correct one char" do
        char = Char.new("b")
        start_state = char.to_machine.start_state

        start_state.transitions.size.should == 1
        first_transition = start_state.transitions.first
        first_transition.symbol.should == :b
      end
    end
  end
end
