require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

module Hopcroft
  module Machine
    describe NfaTransitionTable do
      describe "new_transitions_for" do
        before do
          @table = NfaTransitionTable.new
          @state1 = State.new
          @state2 = State.new(:start_state => false)
          @state3 = State.new(:start_state => false)
          @state4 = State.new(:start_state => false)
          @state5 = State.new(:start_state => false)
        end
        
        it "should return a transition under a symbol" do
          @table.add_state_change @state1, @state2, :a
          
          @table.targets_for(@state1, :a).should == [@state2]
        end
        
        it "should use the correct sym" do
          @table.add_state_change @state1, @state2, :b
          
          @table.targets_for(@state1, :b).should == [@state2]
        end
        
        it "should only find states matching the sym" do
          @table.add_state_change @state1, @state2, :a
          @table.add_state_change @state1, @state3, :b
          
          @table.targets_for(@state1, :a).should == [@state2]
        end
        
        it "should return multiple transitions under the same sym" do
          @table.add_state_change @state1, @state2, :a
          @table.add_state_change @state1, @state3, :a
          
          @table.targets_for(@state1, :a).should == [@state2, @state3]
        end
        
        it "should return an empty array if it cannot find the sym" do
          @table.add_state_change @state1, @state2, :a
        
          @table.targets_for(@state1, :b).should == []
        end
        
        it "should return an empty array if it cannot find the state" do
          @table.add_state_change @state1, @state2, :a
        
          @table.targets_for(mock('a state'), :a).should == []
        end
        
        it "should find an epsilon transition *after* a match" do
          @table.add_state_change @state1, @state2, :a
          @table.add_state_change @state2, @state3, EpsilonTransition
        
          @table.targets_for(@state1, :a).should == [@state2, @state3]
        end
        
        it "should find multiple epsilon transitions" do
          @table.add_state_change @state1, @state2, :a
          @table.add_state_change @state2, @state3, EpsilonTransition
          @table.add_state_change @state2, @state4, EpsilonTransition
        
          @table.targets_for(@state1, :a).should == [@state2, @state3, @state4]
        end
          
        it "should follow epsilon transitions following other epsilon transitions *after* a match" do
          @table.add_state_change @state1, @state2, :a
          @table.add_state_change @state2, @state3, EpsilonTransition
          @table.add_state_change @state3, @state4, EpsilonTransition
        
          @table.targets_for(@state1, :a).should == [@state2, @state3, @state4]
        end
        
        it "should not follow a sym after matching the sym" do
          @table.add_state_change @state1, @state2, :a
          @table.add_state_change @state2, @state3, :a
          
          @table.targets_for(@state1, :a).should == [@state2]
        end
        
        it "should not follow a sym after matching a sym when epsilon transitions connect the syms" do
          @table.add_state_change @state1, @state2, :a
          @table.add_state_change @state2, @state3, EpsilonTransition
          @table.add_state_change @state3, @state4, :a
          
          @table.targets_for(@state1, :a).should == [@state2, @state3]
        end
        
        it "should not find other (non-epsilon) transitions after a match" do
          @table.add_state_change @state1, @state2, :a
          @table.add_state_change @state2, @state3, :a
          @table.add_state_change @state2, @state3, EpsilonTransition
          @table.add_state_change @state3, @state4, :a
        
          @table.targets_for(@state1, :a).should == [@state2, @state3]
        end
        
        it "should match a char under an AnyCharTransition" do
          @table.add_state_change @state1, @state2, AnyCharTransition
          
          @table.targets_for(@state1, :a).should == [@state2]
        end
        
        it "should match any char" do
          @table.add_state_change @state1, @state2, AnyCharTransition
          
          @table.targets_for(@state1, :b).should == [@state2]
        end
      end
    end
  end
end
