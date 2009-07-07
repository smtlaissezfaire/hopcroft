require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Machine
    describe Transition do
      before do
        @state = mock(State)
      end

      it "should have a symbol" do
        t = Transition.new(:foo, @state)
        t.symbol.should == :foo
      end

      it "should convert a string symbol given to a symbol" do
        t = Transition.new("foo", @state)
        t.symbol.should == :foo
      end

      it "should have the transition state" do
        t = Transition.new(:foo, @state)
        t.state.should == @state
      end
    end
  end
end
