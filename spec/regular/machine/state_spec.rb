require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Regular
  module Machine
    describe State do
      it "should have no transitions to begin with" do
        s = State.new
        s.transitions.should == []
      end
   
      it "should be able to add transitions" do
        s = State.new
        s.add_transition :foo
        s.transitions.size.should == 1
      end

      it "should be a start state" do
        s = State.new
        s.should be_a_start_state
      end

      it "should have start state assigned" do
        s = State.new
        s.start_state = false
        s.should_not be_a_start_state
      end

      it "should not be a final state by default" do
        s = State.new
        s.should_not be_a_final_state
      end

      it "should have the final state as assignable" do
        s = State.new
        s.final_state = true
        s.should be_a_final_state
      end

      describe "transitions" do
        before do
          @state = State.new
        end

        it "should create a transition when calling add_transition" do
          @state.add_transition :foo
          @state.transitions.first.should be_a_kind_of(Transition)
        end

        it "should pass on the symbol to the transition" do
          @state.add_transition :baz
          transition = @state.transitions.first
          transition.symbol.should == :baz
        end

        it "should construct a new state when none provided" do
          @state.add_transition :foo
          transition = @state.transitions.first
          transition.state.should be_a_kind_of(State)
        end

        it "should not have the new state as the start state" do
          @state.add_transition :foo
          transition = @state.transitions.first
          transition.state.should_not be_a_start_state
        end

        it "should be able to mark the new state as a final state" do
          @state.add_transition :foo, :final => true
          transition = @state.transitions.first
          transition.state.should be_a_final_state
        end

        it "should take another state as the transition target" do
          state = mock('state', :null_object => true)

          @state.add_transition :foo, state
          transition = @state.transitions.first
          transition.state.should == state
        end

        it "should set the other state to start = false" do
          state = State.new(:start_state => true)

          @state.add_transition :foo, state
          transition = @state.transitions.first
          
          state.should_not be_a_start_state
        end
      end
    end
  end
end
