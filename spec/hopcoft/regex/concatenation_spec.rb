require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Regex
    describe Concatenation do
      it "should initialize with a series of args" do
        one, two = mock, mock

        concat = Concatenation.new one, two
        concat.to_a.should == [one, two]
      end

      describe "to_regex_s" do
        it "should return the regex of the two objs" do
          one = mock :to_regex_s => "foo"
          two = mock :to_regex_s => "bar"

          Concatenation.new(one, two).to_regex_s.should == "foobar"
        end

        it "should use the correct regexs" do
          one = mock :to_regex_s => "a"
          two = mock :to_regex_s => "b"

          Concatenation.new(one, two).to_regex_s.should == "ab"
        end
      end

      describe "matches?" do
        it "should match a single char" do
          concat = Concatenation.new(Char.new("a"))
          concat.matches?("a").should be_true
        end

        it "should match a regex of the two regexs put together" do
          pending 'FIXME: Epsilon transitions are currently consuming characters' do
            one = Char.new("a")
            two = Char.new("b")
            
            concat = Concatenation.new(one, two)
            concat.matches?("ab").should be_true
          end
        end
      end
    end
  end
end
