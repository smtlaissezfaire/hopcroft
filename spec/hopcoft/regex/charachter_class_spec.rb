require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Regex
    describe CharacterClass do
      describe "checking for valid expressions" do
        it "should not be valid with e-a" do
          lambda {
            CharacterClass.new("e-a")
          }.should raise_error(CharacterClass::InvalidCharacterClass)
        end
        
        it "should be valid with one char" do
          lambda {
            CharacterClass.new("a")
          }.should_not raise_error
        end
   
        it "should be valid with a-e" do
          klass = CharacterClass.new("a-e")
          klass.expression.should == "a-e"
        end
   
        it "should be invalid if the second char comes before the first in the alphabet" do
          lambda {
            CharacterClass.new("b-a")
          }.should raise_error
        end
   
        it "should allow multiple sets of ranges" do
          lambda {
            CharacterClass.new("a-zA-Z")
          }.should_not raise_error
        end

        it "should have the regex string" do
          CharacterClass.new("a-c").to_regex_s.should == "[a-c]"
        end
      end

      describe "matching" do
        it "should match an a in [a-z]" do
          klass = CharacterClass.new("a-z")
          klass.matches?("a").should be_true
        end

        it "should match b in [a-z]" do
          klass = CharacterClass.new("a-z")
          klass.matches?("b").should be_true
        end

        it "should match an X in [A-Z]" do
          klass = CharacterClass.new("A-Z")
          klass.matches?("X").should be_true
        end

        it "should not match an a in [A-Z]" do
          klass = CharacterClass.new("A-Z")
          klass.matches?("a").should be_false
        end

        it "should match a number in [0-9]" do
          klass = CharacterClass.new("0-9")
          klass.matches?("0").should be_true
        end

        it "should match in a multi-range expression [0-9a-eA-E]"
      end
    end
  end
end
