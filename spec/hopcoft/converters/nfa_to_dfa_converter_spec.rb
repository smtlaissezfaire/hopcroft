require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Converters
    describe NfaToDfaConverter do
      before do
        @nfa = Machine::StateMachine.new
      end
      
      it "should take an state machine" do
        NfaToDfaConverter.new(@nfa).nfa.should equal(@nfa)
      end
      
      describe "conversion" do
        before do
          @converter = NfaToDfaConverter.new(@nfa)
        end
        
        it "should build a new state machine" do
          @converter.convert.should be_a_kind_of(Machine::StateMachine)
        end
        
        it "should have a start state" do
          @converter.convert.start_state.should_not be_nil
        end
        
        it "should keep a machine with a start state + no other states" do
          @converter.convert.start_state.transitions.should == []
        end
        
        describe "with a dfa: state1(start) -> state2" do
          it "should create a new machine a transition" do
            @nfa.start_state.add_transition :symbol => :foo

            conversion = @converter.convert
            conversion.start_state.transitions.size.should == 1
          end
        
          it "should create the new machine with the symbol :foo" do
            @nfa.start_state.add_transition :symbol => :foo
                  
            conversion = @converter.convert
            conversion.start_state.transitions.first.symbol.should equal(:foo)
          end
          
          it "should use the correct symbol" do
            @nfa.start_state.add_transition :symbol => :bar
                  
            conversion = @converter.convert
            conversion.start_state.transitions.first.symbol.should equal(:bar)
          end
          
          it "should not have an identical (object identical) start state" do
            conversion = @converter.convert
            @nfa.start_state.should_not equal(conversion.start_state)
          end
        end
        
        describe "a dfa with state1 -> state2 -> state3" do
          before do
            state2 = @nfa.start_state.add_transition :symbol => :foo
            state3 = state2.add_transition           :symbol => :bar
          end
          
          it "should have a transition to state2" do
            conversion = @converter.convert
            conversion.start_state.transitions.size.should == 1
          end
          
          it "should have a transition to state3" do
            conversion = @converter.convert
            conversion.start_state.transitions.first.state.transitions.size.should == 1
          end
        end
        
        describe "a dfa with a start state which loops back to itself (on a sym)" do
          before do
            start_state = @nfa.start_state
            start_state.add_transition :symbol => :f, :state => start_state
            
            @conversion = @converter.convert
          end
          
          it "should have a start state" do
            @conversion.start_state.should_not be_nil
          end
          
          it "should have one transition on the start state" do
            @conversion.start_state.transitions.size.should == 1
          end
          
          it "should transition back to itself" do
            @conversion.start_state.transitions.first.state.should equal(@conversion.start_state)
          end
        end
        
        describe "an nfa with start state leading to two different states on the same symbol" do
          before do
            @nfa.start_state.add_transition :symbol => :a
            @nfa.start_state.add_transition :symbol => :a
            
            @conversion = @converter.convert
          end
          
          it "should only have one transition out of the start state" do
            @conversion.start_state.transitions.size.should == 1
          end
        end
      end
    end
  end
end