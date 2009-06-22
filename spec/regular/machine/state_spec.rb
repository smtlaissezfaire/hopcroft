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

        describe "==" do
          before do
            @one = State.new
            @two = State.new
          end

          it "should be equal to another with no transitions" do
            @one.should == @two
            @two.should == @one
          end

          it "should not be equal to another with transitions" do
            @two.add_transition :foo

            @one.should_not == @two
            @two.should_not == @one
          end

          it "should be equal to another with the same transitions" do
            @one.add_transition :foo
            @two.add_transition :foo

            @one.should == @one
            @two.should == @two
          end

          it "should not be equal to another state if one is a final state, but the other isn't" do
            @one.final_state = true
            
            @one.should_not == @two
            @two.should_not == @one
          end

          it "should be equal to another with the same transitions in a different order" do
            @one.add_transition :foo
            @one.add_transition :bar
            
            @two.add_transition :bar
            @two.add_transition :foo

            @one.should == @two
            @two.should == @one
          end

          it "should not be == to a plain object one which does not respond_to? final state" do
            @one.should_not == Object.new
          end

          it "should not be == to an object which does not respond_to? transitions" do
            o = Object.new
            
            def o.final_state?
              false
            end
            
            @one.should_not == o
          end
        end
      end
    end
  end
end
