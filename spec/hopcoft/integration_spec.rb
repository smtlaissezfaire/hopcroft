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
    
    describe "the regex /a*/" do
      before do
        @regex = Regex.compile("a*")
      end
      
      it "should be matched by 'a'" do
        @regex.should be_matched_by("a")
      end
      
      it "should be matched by the empty string" do
        @regex.should be_matched_by("")
      end
      
      it "should be matched by 'aa'" do
        @regex.should be_matched_by("aa")
      end
      
      it "should be matched by 'aaa'" do
        @regex.should be_matched_by("aaa")
      end
      
      it "should not be matched by 'aab'" do
        @regex.should_not be_matched_by("aab")
      end
    end
    
    describe "the regex /a+/" do
      before do
        @regex = Regex.compile("a+")
      end
      
      it "should be matched by 'a'" do
        @regex.should be_matched_by("a")
      end
      
      it "should NOT be matched by the empty string" do
        @regex.should_not be_matched_by("")
      end
      
      it "should be matched by 'aa'" do
        @regex.should be_matched_by("aa")
      end
      
      it "should not be matched by 'aab'" do
        @regex.should_not be_matched_by("aab")
      end
      
      it "should be matched by 'aaa'" do
        @regex.matches?("aaa")
        @regex.should be_matched_by("aaa")
      end
    end
    
    describe "the regex /a|b/" do
      before do
        @regex = Regex.compile("a|b")
      end
      
      it "should be matched by an 'a'" do
        @regex.should be_matched_by("a")
      end
      
      it "should be matched by a 'b'" do
        @regex.should be_matched_by("b")
      end
      
      it "should not be matched by a 'c'" do
        @regex.should_not be_matched_by("c")
      end
      
      it "should not be matched with the string 'ab'" do
        @regex.matched_by?("ab")
        @regex.should_not be_matched_by("ab")
      end
    end
    
    describe "the regex /(a|b)+/" do
      before do
        @regex = Regex.compile("(a|b)+")
      end
      
      it "should not match the empty string" do
        @regex.should_not be_matched_by("")
      end
      
      it "should match an a" do
        @regex.should be_matched_by("a")
      end
      
      it "should match 'b'" do
        @regex.should be_matched_by("b")
      end
        
      it "should match 'aaa'" do
        @regex.should be_matched_by("aaa")
      end
        
      it "should match 'bbb'" do
        @regex.should be_matched_by("bbb")
      end
        
      it "should match 'ababababbbaaa'" do
        @regex.should be_matched_by('ababababbbaaa')
      end
      
      it "should not be matched if it contains a different char" do
        @regex.should_not be_matched_by("ababbbbaacaab")
      end
    end
    
    describe "the regex (a|b)+x" do
      before do
        @regex = Regex.compile("(a|b)+x")
      end
      
      it "should match 'ax'" do
        @regex.should be_matched_by("ax")
      end
      
      it "should match 'bx'" do
        @regex.should be_matched_by("bx")
      end
      
      it "should match 'ababx'" do
        @regex.should be_matched_by("ababx")
      end
      
      it "should not match 'x'" do
        @regex.should_not be_matched_by("x")
      end
    end
  end
end
