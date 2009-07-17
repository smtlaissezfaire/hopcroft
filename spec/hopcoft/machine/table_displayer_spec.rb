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
          state = State.new

          @hash[state] = { :transition => [state] }

          @displayer.header.should == ["", "transition"]
        end

        it "should convert states to state names in the body" do
          state = State.new

          @hash[state] = { :transition => [state] }
          @displayer.body.should == [[state.name, state.name]]
        end

        it "should join multiple states with a comma (for an nfa)" do
          state1 = State.new(:name => "State 1")
          state2 = State.new(:name => "State 2")
          
          @hash[state1] = { :transition => [state1, state2] }

          @displayer.body.should == [["State 1", "State 1, State 2"]]
        end

        it "should display an empty string as an empty string (when there is no state transition" do
          state = State.new(:name => "State 1")
          @hash[state] = { :transition => [] }
          
          @displayer.body.should == [["State 1", ""]]
        end

        it "should have the header + footer combined in to_a" do
          state = State.new(:name => "A")

          @hash[state] = { :transition => [state] }

          @displayer.to_a.should == [["", "transition"], [["A", "A"]]]
        end

        it "should output a table" do
          state = State.new(:name => "A")

          @hash[state] = { :transition => [state] }

          @displayer.to_s.should == <<-HERE
+---+------------+
|   | transition |
+---+------------+
| A | A          |
+---+------------+
HERE
        end
      end
    end
  end
end
