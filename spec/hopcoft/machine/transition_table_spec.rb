require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Machine
    describe TransitionTable do
      describe "start states" do
        before do
          @table = TransitionTable.new
        end

        it "should have a state when a transition is added from the start state to an end state" do
          start_state = mock(State, :start_state? => true)
          second_state = mock(State, :start_state? => false)
          @table.add_state_change(start_state, second_state, :foo)
          
          @table.start_state.should == start_state
        end

        it "should only add the start state once per object" do
          start_state = mock(State, :start_state? => true)
          second_state = mock(State, :start_state? => false)
          third_state  = mock(State, :start_state? => false)

          @table.add_state_change(start_state, second_state, :foo)
          @table.add_state_change(start_state, third_state, :bar)
          
          @table.start_state.should == start_state
        end
      end

      describe "adding a state change" do
        before do
          @table = TransitionTable.new
        end

        it "should create a two dimensional entry, with [from_state][transition] = [to_state]" do
          from = mock(State, :start_state? => false)
          to   = mock(State, :start_state? => false)

          @table.add_state_change(from, to, :a)
          
          @table.entries_for(from, :a).should == [to]
        end

        it "should be able to use strings when finding a start state" do
          from = mock(State, :start_state? => false)
          to   = mock(State, :start_state? => false)

          @table.add_state_change(from, to, :a)
          
          @table.entries_for(from, "a").should == [to]
        end

        it "should be able to use a string when creating the table" do
          from = mock(State, :start_state? => false)
          to   = mock(State, :start_state? => false)

          @table.add_state_change(from, to, "a")
          
          @table.entries_for(from, :a).should == [to]
        end

        it "should be able to use multiple transitions from the same state" do
          from          = mock(State, :start_state? => false)
          first_result  = mock(State, :start_state? => false)
          second_result = mock(State, :start_state? => false)

          @table.add_state_change(from, first_result,  :a)
          @table.add_state_change(from, second_result, :b)
          
          @table.entries_for(from, :a).should == [first_result]
          @table.entries_for(from, :b).should == [second_result]
        end

        it "should be able to use the same transition symbol to different states (for an NFA)" do
          from          = mock(State, :start_state? => false)
          first_result  = mock(State, :start_state? => false)
          second_result = mock(State, :start_state? => false)

          @table.add_state_change(from, first_result,  :a)
          @table.add_state_change(from, second_result, :a)
          
          @table.entries_for(from, :a).should == [first_result, second_result]
        end

        it "should have an entry for an epsilon transition under any symbol" do
          from = State.new :start_state => true
          to = from.add_transition :epsilon => true

          transition = from.transitions.first.symbol
          
          @table.add_state_change(from, to, transition)

          @table.entries_for(from, :a).should == [to]
        end

        it "should have a transition for an 'any' transition" do
          from = State.new :start_state => true
          to = from.add_transition :any => true

          transition = from.transitions.first.symbol

          @table.add_state_change from, to, transition

          @table.entries_for(from, :a).should == [to]
        end
      end

      describe "entries_for" do
        before do
          @table = TransitionTable.new
          @state = mock(State, :start_state? => false, :final? => false)
          @transition = :foo
        end

        it "should reutrn an empty array if it indexes the state, but no transitions for that state" do
          @table.add_state_change(@state, @state, :foo)

          @table.entries_for(@state, :bar).should == []
        end

        it "should return an empty array if it does not index the state" do
          @table.entries_for(@state, :foo).should == []
        end
      end

      describe "matching a symbol" do
        before do
          @table = TransitionTable.new
        end

        it "should match if one symbol in the table, and the symbol is given" do
          start_state = mock(State, :final? => false, :start_state? => true)
          final_state = mock(State, :final? => true,  :start_state? => false)
          
          @table.add_state_change(start_state, final_state, :foo)

          @table.matches?([:foo]).should be_true
        end

        it "should not match if there are no start states" do
          @table.matches?([:foo]).should be_false
        end

        it "should not match when it cannot index the transition" do
          start_state = mock(State, :final? => false, :start_state? => true)
          final_state = mock(State, :final? => true,  :start_state? => false)
          
          @table.add_state_change(start_state, final_state, :foo)

          @table.matches?([:bar]).should be_false
        end

        it "should not match if the last state in the input is not a final state" do
          start_state = mock(State, :final? => false, :start_state? => true)
          final_state = mock(State, :final? => false,  :start_state? => false)
          
          @table.add_state_change(start_state, final_state, :foo)

          @table.matches?([:foo]).should be_false
        end

        it "should not match if there is no start state" do
          start_state = mock(State, :final? => false, :start_state? => false)
          final_state = mock(State, :final? => true,  :start_state? => false)
          
          @table.add_state_change(start_state, final_state, :foo)

          @table.matches?([:foo]).should be_false
        end

        it "should match when following two symbols" do
          start_state = mock(State, :final? => false, :start_state? => true)
          state_one   = mock(State, :final? => false, :start_state? => false)
          state_two   = mock(State, :final? => true,  :start_state? => false)

          @table.add_state_change start_state, state_one, :one
          @table.add_state_change state_one,   state_two, :two

          @table.matches?([:one, :two]).should be_true
        end

        it "should not match when following two symbols, and the last is not a final state" do
          start_state = mock(State, :final? => false,  :start_state? => true)
          state_one   = mock(State, :final? => false,  :start_state? => false)
          state_two   = mock(State, :final? => false,  :start_state? => false)

          @table.add_state_change start_state, state_one, :one
          @table.add_state_change state_one,   state_two, :two

          @table.matches?([:one, :two]).should be_false
        end

        it "should match a NFA, where a start state leads to one of two possible final states" do
          start_state = mock(State, :final? => false,  :start_state? => true)
          state_one   = mock(State, :final? => false,  :start_state? => false)
          state_two   = mock(State, :final? => true,  :start_state? => false)

          @table.add_state_change start_state, state_one, :one
          @table.add_state_change start_state, state_two, :one

          @table.matches?([:one]).should be_true
        end

        it "should not match when the one state does not transition to the other" do
          start_state = mock(State, :final? => false, :start_state? => true)
          state_one   = mock(State, :final? => false, :start_state? => false)
          state_two   = mock(State, :final? => true,  :start_state? => false)

          @table.add_state_change start_state, state_one, :one
          @table.add_state_change start_state, state_two, :two

          @table.matches?([:one, :two]).should be_false
        end

        it "should not consume any chars under an epsilon transition" do
          start_state = mock(State, :final? => false, :start_state? => true)
          state_two   = mock(State, :final? => true, :start_state? => false)

          @table.add_state_change start_state, state_two, EpsilonTransition

          @table.matches?([]).should be_true
        end
      end

      describe "inspect" do
        before do
          @table = TransitionTable.new
          @displayer = mock TableDisplayer
        end

        it "should output a state table" do
          TableDisplayer.should_receive(:new).with(@table).and_return @displayer
          @displayer.should_receive(:to_s)
          
          @table.inspect
        end
      end
    end
  end
end
