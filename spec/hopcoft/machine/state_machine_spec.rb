require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Machine
    describe StateMachine do
      before do
        @machine = StateMachine.new
      end

      it "should have an empty list of states when beginning" do
        @machine.states.should be_empty
      end

      it "should have an empty list of start states when beginning" do
        @machine.start_states.should be_empty
      end

      it "should be able to add a start state" do
        @machine.build_start_state
        @machine.start_states.should_not be_empty
        @machine.states.should_not be_empty
      end

      it "should set the start state on the first state to a start state" do
        state = State.new
        state.should be_a_start_state
      end

      it "should be able to traverse a list of states" do
        state = State.new
        second_state = State.new
        state.add_transition(:symbol => :foo, :state => second_state)

        @machine.build_start_state(state)
        @machine.states.should == [state, second_state]
      end

      describe "new_with_start_state" do
        it "should return a new machine" do
          StateMachine.new_with_start_state.should be_a_kind_of(StateMachine)
        end

        it "should have a start state" do
          m = StateMachine.new_with_start_state
          m.start_state.should be_a_kind_of(State)
        end
      end

      describe "==" do
        before do
          @one = StateMachine.new
          @two = StateMachine.new
        end

        it "should be equal to another where both have no states (epsilon transitions" do
          @one.should == @two
          @two.should == @one
        end

        it "should not be equal if one has no states, and the other has one state" do
          @one.build_start_state
          @one.should_not == @two
          @two.should_not == @one
        end

        it "should be equal with two states being equal" do
          @one.build_start_state
          @two.build_start_state

          @one.should == @two
          @two.should == @one
        end

        it "should not be == to a plain object one which does not respond_to? states" do
          StateMachine.new.should_not == Object.new
        end

        it "should be equal to another with different states, but which minimizes to the same machine"
      end

      describe "building the transition table" do
        before do
          @machine = StateMachine.new
        end
        
        it "should be empty with no start state" do
          @machine.state_table.should be_empty
        end
        
        it "should index a start state with a start state with no transitions" do
          @machine.build_start_state
          @machine.state_table.should be_empty
        end
        
        it "should match a transition of the start state to another state" do
          start_state = @machine.build_start_state
          second_state = start_state.add_transition :symbol => :foo
          
          @machine.state_table.entries_for(start_state, :foo).should == [second_state]
        end
        
        it "should match multiple transitions on the same key (a NFA)" do
          start_state = @machine.build_start_state
          state_one = start_state.add_transition :symbol => :foo
          state_two = start_state.add_transition :symbol => :foo
          
          @machine.state_table.entries_for(start_state, :foo).should == [state_one, state_two]
        end
        
        it "should be able to have a state with a transition to itself" do
          start_state = @machine.build_start_state
          start_state.add_transition :symbol => :foo, :state => start_state
          
          @machine.state_table.entries_for(start_state, :foo).should == [start_state]
        end
      end
    end
  end
end

