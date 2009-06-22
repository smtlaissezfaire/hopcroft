require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Regular
  module Machine
    describe StateMachine do
      before do
        @machine = StateMachine.new
      end

      it "should have an empty list of states when beginning" do
        @machine.states.should == []
      end

      it "should be able to add a start state" do
        state = State.new
        @machine.start_state = state
        @machine.states.should == [state]
      end

      it "should set the start state on the first state to a start state" do
        state = State.new
        @machine.start_state = state
        state.should be_a_start_state
      end

      it "should be able to traverse a list of states" do
        state = State.new
        second_state = State.new
        state.add_transition(:foo, second_state)

        @machine.start_state = state
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
    end
  end
end
