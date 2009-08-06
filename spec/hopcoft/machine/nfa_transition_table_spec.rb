require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Machine
    describe NfaTransitionTable do
      describe "adding a state change" do
        before do
          @table = NfaTransitionTable.new
        end

        it "should create a two dimensional entry, with [from_state][transition] = [to_state]" do
          from = mock(State, :start_state? => false)
          to   = mock(State, :start_state? => false)

          @table.add_state_change(from, to, :a)
          
          @table.targets_for(from, :a).should == [to]
        end

        it "should be able to use strings when finding a start state" do
          from = mock State, :start_state? => true,  :final? => false
          to   = mock State, :start_state? => false, :final? => true

          @table.add_state_change(from, to, :a)
          @table.start_state = from
          
          @table.matches?("a").should be_true
        end

        it "should be able to use multiple transitions from the same state" do
          from          = mock(State, :start_state? => false)
          first_result  = mock(State, :start_state? => false)
          second_result = mock(State, :start_state? => false)

          @table.start_state = from
          @table.add_state_change(from, first_result,  :a)
          @table.add_state_change(from, second_result, :b)
          
          @table.targets_for(from, :a).should == [first_result]
          @table.targets_for(from, :b).should == [second_result]
        end

        it "should be able to use the same transition symbol to different states (for an NFA)" do
          from          = mock(State, :start_state? => false)
          first_result  = mock(State, :start_state? => false)
          second_result = mock(State, :start_state? => false)

          @table.add_state_change(from, first_result,  :a)
          @table.add_state_change(from, second_result, :a)
          
          @table.targets_for(from, :a).should == [first_result, second_result]
        end

        it "should have a transition for an 'any' transition" do
          from = State.new :start_state => true
          to = from.add_transition :any => true

          transition = from.transitions.first.symbol

          @table.add_state_change from, to, transition

          @table.targets_for(from, :a).should == [to]
        end
      end

      describe "targets_for" do
        before do
          @table = NfaTransitionTable.new
          @state = mock(State, :start_state? => false, :final? => false)
          @transition = :foo
        end

        it "should reutrn an empty array if it indexes the state, but no transitions for that state" do
          @table.add_state_change(@state, @state, :foo)

          @table.targets_for(@state, :bar).should == []
        end

        it "should return an empty array if it does not index the state" do
          @table.targets_for(@state, :foo).should == []
        end
      end

      describe "matching a symbol" do
        before do
          @table = NfaTransitionTable.new
        end

        it "should match if one symbol in the table, and the symbol is given" do
          start_state = mock(State, :final? => false, :start_state? => true)
          final_state = mock(State, :final? => true,  :start_state? => false)

          @table.start_state = start_state
          @table.add_state_change(start_state, final_state, :foo)

          @table.matches?([:foo]).should be_true
        end

        it "should not match when it cannot index the transition" do
          start_state = mock(State, :final? => false, :start_state? => true)
          final_state = mock(State, :final? => true,  :start_state? => false)
          
          @table.start_state = start_state
          @table.add_state_change(start_state, final_state, :foo)

          @table.matches?([:bar]).should be_false
        end

        it "should not match if the last state in the input is not a final state" do
          start_state = mock(State, :final? => false, :start_state? => true)
          final_state = mock(State, :final? => false,  :start_state? => false)
          
          @table.start_state = start_state
          @table.add_state_change(start_state, final_state, :foo)

          @table.matches?([:foo]).should be_false
        end

        it "should raise an error if there is no start state" do
          lambda {
            @table.matches?([:foo])
          }.should raise_error(NfaTransitionTable::MissingStartState)
        end

        it "should match when following two symbols" do
          start_state = mock(State, :final? => false, :start_state? => true)
          state_one   = mock(State, :final? => false, :start_state? => false)
          state_two   = mock(State, :final? => true,  :start_state? => false)

          @table.start_state = start_state
          @table.add_state_change start_state, state_one, :one
          @table.add_state_change state_one,   state_two, :two

          @table.matches?([:one, :two]).should be_true
        end

        it "should not match when following two symbols, and the last is not a final state" do
          start_state = mock(State, :final? => false,  :start_state? => true)
          state_one   = mock(State, :final? => false,  :start_state? => false)
          state_two   = mock(State, :final? => false,  :start_state? => false)

          @table.start_state = start_state
          @table.add_state_change start_state, state_one, :one
          @table.add_state_change state_one,   state_two, :two

          @table.matches?([:one, :two]).should be_false
        end

        it "should match a NFA, where a start state leads to one of two possible final states" do
          start_state = mock(State, :final? => false,  :start_state? => true)
          state_one   = mock(State, :final? => false,  :start_state? => false)
          state_two   = mock(State, :final? => true,  :start_state? => false)

          @table.start_state = start_state
          @table.add_state_change start_state, state_one, :one
          @table.add_state_change start_state, state_two, :one

          @table.matches?([:one]).should be_true
        end

        it "should not match when the one state does not transition to the other" do
          start_state = mock(State, :final? => false, :start_state? => true)
          state_one   = mock(State, :final? => false, :start_state? => false)
          state_two   = mock(State, :final? => true,  :start_state? => false)

          @table.start_state = start_state
          @table.add_state_change start_state, state_one, :one
          @table.add_state_change start_state, state_two, :two

          @table.matches?([:one, :two]).should be_false
        end

        it "should not consume any chars under an epsilon transition" do
          start_state = mock(State, :final? => false, :start_state? => true)
          state_two   = mock(State, :final? => true, :start_state? => false)

          @table.start_state = start_state
          @table.add_state_change start_state, state_two, EpsilonTransition

          @table.matches?([]).should be_true
        end
      end

      describe "inspect" do
        before do
          @table = NfaTransitionTable.new
          @displayer = mock TableDisplayer
        end

        it "should output a state table" do
          TableDisplayer.should_receive(:new).with(@table).and_return @displayer
          @displayer.should_receive(:to_s)
          
          @table.inspect
        end

        it "should display 'Empty table' when empty" do
          @table.inspect.should == "\nEmpty table"
        end

        it "should be able to display a start state with no transitions" do
          start_state = State.new(:start_state => true, :name => "Foo")

          @table.start_state = start_state
          @table.inspect.should include("Foo")
        end
      end

      describe "to_hash" do
        it "should return a hash" do
          NfaTransitionTable.new.to_hash.class.should == Hash
        end
      end
      
      describe "initial states" do
        describe "for a start_state to an epsilon transition" do
          # +--------------+--------------------------------------+-------------+
          # |              | Hopcroft::Machine::EpsilonTransition |      a      |
          # +--------------+--------------------------------------+-------------+
          # | -> State 207 | State 208                            |             |
          # | State 208    |                                      | * State 209 |
          # +--------------+--------------------------------------+-------------+
          before do
            @state1 = State.new :start_state => true,  :name => "State 1"
            @state2 = State.new :start_state => false, :name => "State 2"
            @state3 = State.new :start_state => false, :name => "State 3", :final_state => true
            
            @table = NfaTransitionTable.new
            @table.add_state_change @state1, @state2, EpsilonTransition
            @table.add_state_change @state2, @state3, :a
            @table.start_state = @state1
          end
          
          it "should have state 1 as an initial state (it is a start state)" do
            @table.initial_states.should include(@state1)
          end
          
          it "should have state 2 as an initial state (it has an epsilon transition from the start state)" do
            @table.initial_states.should include(@state2)
          end
          
          it "should not have state 3 as an initial state" do
            @table.initial_states.should_not include(@state3)
          end
        end
      end
    end
  end
end
