require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Machine
    describe DfaTransitionTable do
      before do
        @table = DfaTransitionTable.new
        @state = State.new
      end
      
      it "should have the start state as assignable" do
        @table.start_state = @state
        @table.start_state.should equal(@state)
      end
      
      describe "adding state changes" do
        before do
          @state_two = State.new
        end
        
        it "should be able to add a state change with a symbol" do
          @table.add_state_change(@state, @state_two, :symbol)
          @table.has_state_change?(@state, @state_two, :symbol).should be_true
        end
        
        it "should not have a state change if none are provided" do
          @table.has_state_change?(@state, @state_two, :symbol).should be_false
        end
        
        it "should not match the state change if with a different sym" do
          @table.add_state_change(@state, @state_two, :symbol)
          @table.has_state_change?(@state, @state_two, :bar).should be_false
        end
        
        it "should not match the state change with a different starting state" do
          @table.add_state_change(@state, @state_two, :symbol)
          @table.has_state_change?(mock('different state'), @state_two, :symbol).should be_false
        end
        
        it "should not match the state change with a different finishing state" do
          @table.add_state_change(@state, @state_two, :symbol)
          @table.has_state_change?(@state, mock('a different state'), :symbol).should be_false
        end
        
        it "should raise an error if a state change for the state & symbol has already been provided" do
          @table.add_state_change(@state, @state_two, :symbol)
          
          lambda {
            @table.add_state_change(@state, mock("another target"), :symbol)
          }.should raise_error(DfaTransitionTable::DuplicateStateError)
        end
      end
      
      describe "target_for" do
        before do
          @state_two = State.new
        end
        
        it "should be the to symbol of the state change" do
          @table.add_state_change(@state, @state_two, :symbol)
          @table.target_for(@state, :symbol).should == @state_two
        end
        
        it "should return nil if it cannot find the state" do
          @table.add_state_change(@state, @state_two, :symbol)
          @table.target_for(mock("a different state"), :symbol).should be_nil
        end
        
        it "should return nil if it cannot find the symbol" do
          @table.add_state_change(@state, @state_two, :symbol)
          @table.target_for(@state, :foo).should be_nil
        end
      end
      
      describe "to_hash" do
        it "should return a hash" do
          @table.to_hash.should be_a_kind_of(Hash)
        end
        
        it "should return a hash constructed from the table" do
          Hash.should_receive(:new).with(@table)
          @table.to_hash
        end
      end
      
      describe "initial_states" do
        it "should be the start state" do
          @table.start_state = @state
          @table.initial_state.should equal(@state)
        end
      end
      
      describe "next_transitions" do
        it "should be an alias for target_for" do
          @table.method(:next_transitions).should == @table.method(:target_for)
        end
      end
      
      describe "matches?" do
        it "should raise an error if there is no start state" do
          lambda {
            @table.matches?("foo")
          }.should raise_error(DfaTransitionTable::MissingStartState)
        end
        
        describe "with a start state which is a final state, with no transitions" do
          before do
            @state = State.new(:final => true)
            @table.start_state = @state
          end
          
          it "should match the start state with no input chars" do
            @table.should be_matched_by([])
          end
          
          it "should not match when given an input symbol" do
            @table.should_not be_matched_by(["a"])
          end
        end
        
        describe "with only a start state & no final states" do
          before do
            @state = State.new(:final => false)
            @table.start_state = @state
          end
          
          it "should not match with no input" do
            @table.should_not be_matched_by([])
          end
          
          it "should not match when given an input symbol" do
            @table.should_not be_matched_by(["a"])
          end
        end
        
        describe "with a start state which leads to a final state" do
          before do
            @state       = State.new
            @final_state = State.new(:final => true)
            
            @table.start_state = @state
            @table.add_state_change @state, @final_state, "a"
          end
          
          it "should not match when given no input" do
            @table.should_not be_matched_by([])
          end
          
          it "should match when given the one char" do
            @table.should be_matched_by(["a"])
          end
          
          it "should not match when given a different char" do
            @table.should_not be_matched_by(["b"])
          end
          
          it "should not match when given the input symbol repeatedly" do
            @table.should_not be_matched_by(["a", "a"])
          end
          
          it "should return false if it does not match" do
            @table.matched_by?(["a", "a"]).should be_false
          end
        end
      end
      
      describe "inspect" do
        it "should call TableDisplayer" do
          TableDisplayer.should_receive(:new)
          @table.inspect
        end
        
        it "should output a display with rows + columns (it should not raise an error)" do
          state1, state2 = State.new, State.new
          
          @table.add_state_change(state1, state2, :a_sym)
          
          lambda {
            @table.inspect
          }.should_not raise_error
        end
      end
    end
  end
end