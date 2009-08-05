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

      describe "deep_clone" do
        before do
          @to = State.new
        end

        it "should return a transition" do
          t = Transition.new(:sym, @to)
          t.deep_clone.should be_a_kind_of(Transition)
        end

        it "should return a new instance" do
          t = Transition.new(:sym, @to)
          t.deep_clone.should_not equal(t)
        end

        it "should use the symbol" do
          t = Transition.new(:sym, @to)
          t.deep_clone.symbol.should == :sym
        end

        it "should use the correct symbol" do
          t = Transition.new(:foo, @to)
          t.deep_clone.symbol.should == :foo
        end

        it "should have the state" do
          t = Transition.new(:foo, @to)
          t.deep_clone.state.should be_a_kind_of(State)
        end

        it "should call deep_clone on the to state" do
          t = Transition.new(:foo, @to)

          @to.should_receive(:deep_clone)
          t.deep_clone
        end
      end
    end
  end
end
