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
          
          it "should not have the start state as a final state" do
            @nfa.start_state.add_transition :symbol => :foo, :final => true
            conversion = @converter.convert
            conversion.start_state.should_not be_a_final_state
          end
          
          it "should have the final state as final" do
            @nfa.start_state.add_transition :symbol => :foo, :final => true
            conversion = @converter.convert
            conversion.start_state.transitions.first.state.should be_final
          end
          
          it "should not have the final state as a start state" do
            @nfa.start_state.add_transition :symbol => :foo, :final => true
            conversion = @converter.convert
            conversion.start_state.transitions.first.state.should_not be_a_start_state
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
        
        describe "an NFA with an epsilon transition (start -> a -> epsilon -> b)" do
          before do
            two   = @nfa.start_state.add_transition  :symbol => :a
            three = two.add_transition               :symbol => Machine::EpsilonTransition
            four  = three.add_transition             :symbol => :b
            
            @conversion = @converter.convert
          end
          
          it "should have one transition coming from the start state" do
            @conversion.start_state.number_of_transitions.should == 1
          end
          
          it "should have the first transition on an a" do
            @conversion.start_state.transitions.first.symbol.should equal(:a)
          end
          
          it "should have a second transition to a b" do
            second_state = @conversion.start_state.transitions.first.state
            second_state.transitions.size.should == 1
            second_state.transitions.first.symbol.should equal(:b)
          end
        end
        
        describe "with an epsilon transition on the same symbol to two different final states" do
          before do
            two   = @nfa.start_state.add_transition :symbol => :a
            three = @nfa.start_state.add_transition :symbol => :a
            
            @conversion = @converter.convert
          end
          
          it "should have only one transition out of the start state" do
            @conversion.start_state.transitions.size.should == 1
          end
          
          it "should have the transition out of the start state on the symbol" do
            @conversion.start_state.transitions.first.symbol.should == :a
          end
          
          it "should transition to a new state with no transitions" do
            target_state = @conversion.start_state.transitions.first.state
            
            target_state.transitions.should == []
          end
        end
      end
    end
  end
end