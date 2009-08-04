require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Machine
    describe State do
      it "should set the start state on the first state to a start state" do
        state = State.new
        state.should be_a_start_state
      end

      it "should have no transitions to begin with" do
        s = State.new
        s.transitions.should == []
      end
   
      it "should be able to add transitions" do
        s = State.new
        s.add_transition :symbol => :foo
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
        s.should_not be_final
      end

      it "should have the final state as assignable" do
        s = State.new
        s.final_state = true
        s.should be_a_final_state
        s.should be_final
      end

      describe "transitions" do
        before do
          @state = State.new
        end

        it "should create a transition when calling add_transition" do
          @state.add_transition :symbol => :foo
          @state.transitions.first.should be_a_kind_of(Transition)
        end

        it "should pass on the symbol to the transition" do
          @state.add_transition :symbol => :baz
          transition = @state.transitions.first
          transition.symbol.should == :baz
        end

        it "should construct a new state when none provided" do
          @state.add_transition :symbol => :foo
          transition = @state.transitions.first
          transition.state.should be_a_kind_of(State)
        end

        it "should not have the new state as the start state" do
          @state.add_transition :symbol => :foo
          transition = @state.transitions.first
          transition.state.should_not be_a_start_state
        end

        it "should be able to mark the new state as a final state" do
          @state.add_transition :symbol => :foo, :final => true
          transition = @state.transitions.first
          transition.state.should be_a_final_state
        end

        it "should take another state as the transition target" do
          state = mock('state', :null_object => true)

          @state.add_transition :symbol => :foo, :state => state
          transition = @state.transitions.first
          transition.state.should == state
        end

        it "should be able to add transitions recursively" do
          s1 = State.new
          s2 = State.new

          s1.add_transition :state => s2, :epsilon => true
          s2.add_transition :state => s1, :epsilon => true

          table = TransitionTable.new

          s1.add_transitions_to_table(table)
        end
      end

      describe "name" do
        it "should take a name param" do
          state = State.new(:name => "foo")
          state.name.should == "foo"
        end

        it "should auto-assign a state #" do
          State.reset_counter!
          state = State.new
          state.name.should == "State 1"
        end

        it "should assign 'State 2' for the second state created" do
          State.reset_counter!

          State.new
          state2 = State.new

          state2.name.should == "State 2"
        end
      end

      describe "to_s" do
        it "should be aliased to the name" do
          s = State.new
          s.method(:name).should == s.method(:to_s)
        end
      end

      describe "inspect" do
        it "should display the name" do
          s = State.new(:name => "State 1")
          s.inspect.should include("State 1")
        end

        it "should show start state, final state, etc." do
          s = State.new(:name => "State 1", :start_state => true, :final => true)
          s.inspect.should == "State 1 {start: true, final: true, transitions: 0}"
        end

        it "should display the correct value for the start state" do
          s = State.new(:name => "State 1", :start_state => false, :final => true)
          s.inspect.should == "State 1 {start: false, final: true, transitions: 0}"
        end

        it "should display the correct value for the final state" do
          s = State.new(:name => "State 1", :start_state => true, :final => false)
          s.inspect.should == "State 1 {start: true, final: false, transitions: 0}"
        end

        it "should display 1 transition" do
          s = State.new(:name => "State 1", :start_state => true, :final => true)
          s.add_transition

          s.inspect.should == "State 1 {start: true, final: true, transitions: 1}"
        end
      end
    end
  end
end
