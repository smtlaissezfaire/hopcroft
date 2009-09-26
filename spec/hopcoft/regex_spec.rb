require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module Hopcroft
  describe Regex do
    describe "compiling" do
      before do
        @a_regex = Regex::Char.new("a")
        Regex::Parser.stub!(:parse).with("a|regex").and_return @a_regex
      end
      
      it "should parse the regex" do
        Regex::Parser.should_receive(:parse).with("a|regex").and_return @a_regex
        Regex.compile("a|regex")
      end
      
      it "should compile the regex" do
        @a_regex.should_receive(:compile)
        Regex.compile("a|regex")
      end
      
      it "should return the regex" do
        Regex.compile("a|regex").should == @a_regex
      end
    end
  end
end