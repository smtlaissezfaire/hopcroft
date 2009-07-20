require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Machine
    describe TableDisplayer do
      before do
        @hash = Dictionary.new
        @displayer = TableDisplayer.new(@hash)
      end

      describe "converted table" do
        it "should convert symbols to strings in the header" do
          state = State.new(:start_state => false)

          @hash[state] = { :transition => [state] }

          @displayer.header.should == ["", "transition"]
        end

        it "should convert states to state names in the body" do
          state = State.new(:start_state => false)

          @hash[state] = { :transition => [state] }
          @displayer.body.should == [[state.name, state.name]]
        end

        it "should join multiple states with a comma (for an nfa)" do
          state1 = State.new(:name => "State 1", :start_state => false)
          state2 = State.new(:name => "State 2", :start_state => false)
          
          @hash[state1] = { :transition => [state1, state2] }

          @displayer.body.should == [["State 1", "State 1, State 2"]]
        end

        it "should display an empty string as an empty string (when there is no state transition" do
          state = State.new(:name => "State 1", :start_state => false)
          @hash[state] = { :transition => [] }
          
          @displayer.body.should == [["State 1", ""]]
        end

        it "should have the header + footer combined in to_a" do
          state = State.new(:name => "A", :start_state => false)

          @hash[state] = { :transition => [state] }

          @displayer.to_a.should == [["", "transition"], [["A", "A"]]]
        end

        it "should output a table" do
          state = State.new(:name => "A", :start_state => false)

          @hash[state] = { :transition => [state] }

          @displayer.to_s.should == <<-HERE
+---+------------+
|   | transition |
+---+------------+
| A | A          |
+---+------------+
HERE
        end

        it "should display a -> in front of a start state in the first row" do
          state = State.new(:name => "A", :start_state => true)

          @hash[state] = { :transition => [state] }

          @displayer.to_a.should == [["", "transition"], [["-> A", "A"]]]
        end

        it "should use the correct name of the state" do
          state = State.new(:name => "B", :start_state => true)

          @hash[state] = { :transition => [state] }

          @displayer.to_a.should == [["", "transition"], [["-> B", "B"]]]
        end

        it "should display a * next to a final state in the first row" do
          state = State.new(:name => "A", :final => true, :start_state => false)
          
          @hash[state] = { :transition => [state] }

          @displayer.to_a.should == [["", "transition"], [["* A", "A"]]]
        end

        it "should use the correct state name with the star" do
          state = State.new(:name => "B", :final => true, :start_state => false)
          
          @hash[state] = { :transition => [state] }

          @displayer.to_a.should == [["", "transition"], [["* B", "B"]]]
        end

        it "should display a * -> <state-name> if the state is both final and a start state" do
          state = State.new(:name => "A", :final => true, :start_state => true)
          
          @hash[state] = { :transition => [state] }

          @displayer.to_a.should == [["", "transition"], [["* -> A", "A"]]]
        end
      end
    end
  end
end
