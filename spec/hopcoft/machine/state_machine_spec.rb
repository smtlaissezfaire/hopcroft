require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Machine
    describe StateMachine do
      before do
        @machine = StateMachine.new
      end

      it "should have a start state when beginning" do
        @machine.start_state.should be_a_kind_of(State)
      end

      it "should be able to add a start state" do
        state = State.new
      
        @machine.start_state = state
        @machine.start_state.should equal(state)
      end
      
      it "should accept a start state in the constructor" do
        state = State.new
        machine = StateMachine.new(state)
        machine.start_state.should equal(state)
      end

      it "should be able to traverse a list of states" do
        state = State.new
        second_state = State.new
        state.add_transition(:symbol => :foo, :state => second_state)

        @machine.start_state = state
        @machine.states.should == [state, second_state]
      end

      describe "building the transition table" do
        before do
          @machine = StateMachine.new
        end
        
        it "should match a transition of the start state to another state" do
          start_state = @machine.start_state
          second_state = start_state.add_transition :symbol => :foo
          
          @machine.state_table.targets_for(start_state, :foo).should == [second_state]
        end
        
        it "should match multiple transitions on the same key (a NFA)" do
          start_state = @machine.start_state
          state_one = start_state.add_transition :symbol => :foo
          state_two = start_state.add_transition :symbol => :foo
          
          @machine.state_table.targets_for(start_state, :foo).should == [state_one, state_two]
        end
        
        it "should be able to have a state with a transition to itself" do
          start_state = @machine.start_state
          start_state.add_transition :symbol => :foo, :state => start_state
          
          @machine.state_table.targets_for(start_state, :foo).should == [start_state]
        end

        it "should add a start state with no transitions to the table" do
          start_state = @machine.start_state
          
          @machine.state_table.start_state.should == start_state
        end
      end
    end
  end
end

