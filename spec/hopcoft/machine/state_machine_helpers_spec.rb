require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Machine
    describe StateMachineHelpers do
      before do
        @obj = Object.new
        @obj.extend StateMachineHelpers
      end

      describe "epsilon_closure" do
        it "should be an empty list when given an empty list" do
          @obj.epsilon_closure([]).should == []
        end

        it "should return the state when the state has no transitions" do
          state = State.new

          @obj.epsilon_closure([state]).should == [state]
        end

        it "should return an epsilon closure target" do
          state1 = State.new
          state2 = State.new
          
          state1.add_transition :state => state2, :epsilon => true
          
          @obj.epsilon_closure([state1]).should include(state2)
        end

        it "should not return a target with a state1 => state2 on a regular transition symbol" do
          state1 = State.new
          state2 = State.new

          state1.add_transition :symbol => :sym, :state => state2

          @obj.epsilon_closure([state1]).should_not include(state2)
        end

        it "should follow epsilon targets from several states" do
          state1 = State.new
          state2 = State.new
          state1.add_transition :state => state2, :epsilon => true
  
          state3 = State.new
          state4 = State.new
          state3.add_transition :state => state4, :epsilon => true
  
          @obj.epsilon_closure([state1, state3]).should include(state2)
          @obj.epsilon_closure([state1, state3]).should include(state4)
        end

        it "should find multiple levels of epsilon transitions" do
          state1 = State.new
          state2 = State.new
          state3 = State.new
          
          state1.add_transition :state => state2, :epsilon => true
          state2.add_transition :state => state3, :epsilon => true

          @obj.epsilon_closure([state1]).should include(state2)
          @obj.epsilon_closure([state1]).should include(state3)
        end
      end
    end
  end
end
