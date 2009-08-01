require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module Hopcroft
  describe "Integration tests" do
    describe "the regex /a/" do
      before do
        @regex = Regex.compile("a")
      end
      
      it "should match 'a'" do
        @regex.should be_matched_by("a")
      end
      
      it "should not match 'b'" do
        @regex.should_not be_matched_by("b")
      end
      
      it "should not match 'abasdfasdf'" do
        @regex.should_not be_matched_by('abasdfasdf')
      end
    end
    
    describe "the regex /ab/" do
      before do
        @regex = Regex.compile("ab")
      end
      
      it "should match 'ab'" do
        @regex.should be_matched_by("ab")
      end
      
      it "should not match 'x'" do
        @regex.should_not be_matched_by("x")
      end
      
      it "should not match 'ba'" do
        @regex.should_not be_matched_by("ba")
      end
    end
  end
end