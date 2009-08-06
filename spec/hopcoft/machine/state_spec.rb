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

          table = NfaTransitionTable.new

          s1.add_transitions_to_table(table)
        end
        
        describe "passed :machine => m" do
          before do
            @state   = State.new
            @machine = StateMachine.new
          end
          
          it "should add a transition to another state machines first state" do
            other_machine_start_state = @machine.start_state
            
            @state.add_transition :machine => @machine

            @state.transitions.first.state.should == other_machine_start_state
          end
          
          it "should add the transition as an epsilon transition" do
            @state.add_transition :machine => @machine
            
            @state.transitions.first.should be_a_kind_of(EpsilonTransition)
          end
          
          it "should no longer have the other machines start state as a start state in this machine" do
            other_machine_start_state = @machine.start_state
            
            @state.add_transition :machine => @machine
            
            @state.transitions.first.state.should_not be_a_start_state
          end
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

      describe "deep_clone" do
        before do
          @state = State.new
        end

        it "should be of class State" do
          clone = @state.deep_clone
          clone.should be_a_kind_of(State)
        end

        it "should be a new instance" do
          clone = @state.deep_clone
          clone.should_not equal(@state)
        end

        it "should be a final state if the original was a final state" do
          @state.final_state = true
          clone = @state.deep_clone
          clone.should be_a_final_state
        end

        it "should not have the same transition objects" do
          @state.add_transition
          transition = @state.transitions.first

          clone = @state.deep_clone
          clone.transitions.first.should_not equal(transition)
        end

        it "should have one transition if the original had one transition" do
          @state.add_transition

          clone = @state.deep_clone
          clone.transitions.size.should == 1
        end

        it "should have two transitions if the original had two transition" do
          @state.add_transition
          @state.add_transition

          clone = @state.deep_clone
          clone.transitions.size.should == 2
        end

        it "should have a transition as a Transition object" do
          @state.add_transition

          clone = @state.deep_clone
          clone.transitions.first.should be_a_kind_of(Transition)
        end

        it "should call deep_clone on the transitions" do
          @state.add_transition

          @state.transitions.first.should_receive(:deep_clone)
          @state.deep_clone
        end
      end

      describe "substates" do
        before do
          @state = State.new
        end
        
        it "should have none with no transitions" do
          @state.substates.should == []
        end
        
        it "should have a state which is linked to by a transition" do
          new_state = @state.add_transition :symbol => :foo
          @state.substates.should == [new_state]
        end
        
        it "should have multiple states" do
          one = @state.add_transition :symbol => :foo
          two = @state.add_transition :symbol => :foo
          
          @state.substates.should == [one, two]
        end

        it "should show states of the states (should find the states substates recursively)" do
          substate     = @state.add_transition   :symbol => :foo
          sub_substate = substate.add_transition :symbol => :foo

          @state.substates.should == [substate, sub_substate]
        end
      end
    end
  end
end
