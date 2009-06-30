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

      describe "==" do
        it "should be equal to another with same symbol and state" do
          state = State.new
          t1 = Transition.new(:foo, state)
          t2 = Transition.new(:foo, state)

          t1.should == t2
          t2.should == t1
        end

        it "should not be equal to another with the same state, but a different symbol" do
          state = State.new
          t1 = Transition.new(:foo, state)
          t2 = Transition.new(:bar, state)

          t1.should_not == t2
          t2.should_not == t1
        end

        it "should be equal to another with the same transition and states which are ==" do
          state1 = State.new
          state2 = State.new
          t1 = Transition.new(:foo, state1)
          t2 = Transition.new(:foo, state2)

          t1.should == t2
          t2.should == t1
        end

        it "should not be == to a plain object one which does not respond_to? symbol" do
          Transition.new(:foo, State.new).should_not == Object.new
        end

        it "should not be == to an object which does not respond_to? transitions" do
          o = Object.new
          
          def o.symbol
            :sym
          end
            
          Transition.new(:sym, State.new).should_not == o
        end
      end
    end
  end
end
