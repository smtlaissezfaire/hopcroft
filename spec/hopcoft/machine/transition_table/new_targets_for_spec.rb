require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

module Hopcroft
  module Machine
    describe TransitionTable do
      describe "new_transitions_for" do
        before do
          @table = TransitionTable.new
          @state1 = State.new
          @state2 = State.new(:start_state => false)
          @state3 = State.new(:start_state => false)
          @state4 = State.new(:start_state => false)
          @state5 = State.new(:start_state => false)
        end
        
        it "should return a transition under a symbol" do
          @table.add_state_change @state1, @state2, :a
          
          @table.new_targets_for(@state1, :a).should == [@state2]
        end
        
        it "should use the correct sym" do
          @table.add_state_change @state1, @state2, :b
          
          @table.new_targets_for(@state1, :b).should == [@state2]
        end
        
        it "should only find states matching the sym" do
          @table.add_state_change @state1, @state2, :a
          @table.add_state_change @state1, @state3, :b
          
          @table.new_targets_for(@state1, :a).should == [@state2]
        end
        
        it "should return multiple transitions under the same sym" do
          @table.add_state_change @state1, @state2, :a
          @table.add_state_change @state1, @state3, :a
          
          @table.new_targets_for(@state1, :a).should == [@state2, @state3]
        end
        
        it "should return an empty array if it cannot find the sym" do
          @table.add_state_change @state1, @state2, :a
        
          @table.new_targets_for(@state1, :b).should == []
        end
        
        it "should return an empty array if it cannot find the state" do
          @table.add_state_change @state1, @state2, :a
        
          @table.new_targets_for(mock('a state'), :a).should == []
        end
        
        it "should find an epsilon transition *after* a match" do
          @table.add_state_change @state1, @state2, :a
          @table.add_state_change @state2, @state3, EpsilonTransition
        
          @table.new_targets_for(@state1, :a).should == [@state2, @state3]
        end
        
        it "should find multiple epsilon transitions" do
          @table.add_state_change @state1, @state2, :a
          @table.add_state_change @state2, @state3, EpsilonTransition
          @table.add_state_change @state2, @state4, EpsilonTransition
        
          @table.new_targets_for(@state1, :a).should == [@state2, @state3, @state4]
        end
          
        it "should follow epsilon transitions following other epsilon transitions *after* a match" do
          @table.add_state_change @state1, @state2, :a
          @table.add_state_change @state2, @state3, EpsilonTransition
          @table.add_state_change @state3, @state4, EpsilonTransition
        
          @table.new_targets_for(@state1, :a).should == [@state2, @state3, @state4]
        end
        
        it "should not follow a sym after matching the sym" do
          @table.add_state_change @state1, @state2, :a
          @table.add_state_change @state2, @state3, :a
          
          @table.new_targets_for(@state1, :a).should == [@state2]
        end
        
        it "should not follow a sym after matching a sym when epsilon transitions connect the syms" do
          @table.add_state_change @state1, @state2, :a
          @table.add_state_change @state2, @state3, EpsilonTransition
          @table.add_state_change @state3, @state4, :a
          
          @table.new_targets_for(@state1, :a).should == [@state2, @state3]
        end
        
        it "should not find other (non-epsilon) transitions after a match" do
          @table.add_state_change @state1, @state2, :a
          @table.add_state_change @state2, @state3, :a
          @table.add_state_change @state2, @state3, EpsilonTransition
          @table.add_state_change @state3, @state4, :a
        
          @table.new_targets_for(@state1, :a).should == [@state2, @state3]
        end
        
        it "should match an epsilon transition" do
          @table.add_state_change @state1, @state2, EpsilonTransition
          @table.new_targets_for(@state1, :a).should == [@state2]
        end
        
        it "should match multiple epsilon transitions eminating from the same state" do
          @table.add_state_change @state1, @state2, EpsilonTransition
          @table.add_state_change @state1, @state3, EpsilonTransition
          
          @table.new_targets_for(@state1, :a).should == [@state2, @state3]
        end
        
        it "should match a char after matching an epsilon transition" do
          @table.add_state_change @state1, @state2, EpsilonTransition
          @table.add_state_change @state2, @state3, :a
          
          @table.new_targets_for(@state1, :a).should == [@state2, @state3]
        end
        
        it "should match epsilon transitions recursively" do
          @table.add_state_change @state1, @state2, EpsilonTransition
          @table.add_state_change @state2, @state3, EpsilonTransition
          
          @table.new_targets_for(@state1, :a).should == [@state2, @state3]
        end
        
        it "should not match a char after matching through epsilon transition through (Start -> Epsilon -> Match -> Epsilon -> Match)" do
          @table.add_state_change @state1, @state2, EpsilonTransition
          @table.add_state_change @state2, @state3, :a
          @table.add_state_change @state3, @state4, EpsilonTransition
          @table.add_state_change @state4, @state5, :a
          
          @table.new_targets_for(@state1, :a).should == [@state2, @state3, @state4]
        end
        
        it "should match a char under an AnyCharTransition" do
          @table.add_state_change @state1, @state2, AnyCharTransition
          
          @table.new_targets_for(@state1, :a).should == [@state2]
        end
        
        it "should match any char" do
          @table.add_state_change @state1, @state2, AnyCharTransition
          
          @table.new_targets_for(@state1, :b).should == [@state2]
        end
        
        it "should match anychar after an e move" do
          @table.add_state_change @state1, @state2, EpsilonTransition
          @table.add_state_change @state2, @state3, AnyCharTransition
          
          @table.new_targets_for(@state1, :a).should == [@state2, @state3]
        end
      end
    end
  end
end