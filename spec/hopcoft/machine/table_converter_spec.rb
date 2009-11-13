require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Machine
    describe TableConverter do
      before do
        @hash = Dictionary.new
        @converter = TableConverter.new(@hash)
      end

      describe "transition symbols" do
        it "should have no transitions when an empty hash" do
          @converter.transition_symbols.should == []
        end

        it "should have the symbols" do
          @hash[:state1] = { :transition2 => [:state2] }

          @converter.transition_symbols.should == [:transition2]
        end

        it "should have many transition symbols under various states" do
          @hash[:state1] = { :transition1 => [] }
          @hash[:state2] = { :transition2 => [] }

          @converter.transition_symbols.should include(:transition1)
          @converter.transition_symbols.should include(:transition2)
        end

        it "should use all of the transition symbols per state" do
          @hash[:state1] = { :transition_symbol_1 => [], :transition_symbol_2 => [] }

          @converter.transition_symbols.should include(:transition_symbol_1)
          @converter.transition_symbols.should include(:transition_symbol_2)
        end

        it "should only include a transition symbol once, even if listed under multiple states" do
          @hash[:state1] = { :transition_symbol_1 => [] }
          @hash[:state2] = { :transition_symbol_1 => [] }

          @converter.transition_symbols.should == [:transition_symbol_1]
        end

        it "should cache the transition symbols" do
          @hash[:state] = { :one => [] }

          lambda {
            @hash.delete(:state)
          }.should_not change { @converter.transition_symbols.dup }
        end
      end

      describe "primary states" do
        it "should be empty for an empty hash" do
          @converter.primary_states.should == []
        end

        it "should have a state used as an index in the hash" do
          @hash[:one] = {}
          @converter.primary_states.should == [:one]
        end

        it "should cache the primary states" do
          @hash[:one] = {:two => [:three]}

          lambda {
            @hash.delete(:one)
          }.should_not change { @converter.primary_states.dup }
        end
      end

      describe "header" do
        it "should have an empty string with an empty hash" do
          @converter.header.should == [""]
        end

        it "should use the transition symbols, preceeded by an empty string" do
          @hash[:one] = {:two => []}
          @converter.header.should == ["", :two]
        end

        it "should use multiple transition symbols" do
          @hash[:one] = {:trans1 => []}
          @hash[:two] = {:trans2 => []}

          @converter.header.should == ["", :trans1, :trans2]
        end
      end

      describe "body" do
        it "should be empty for an empty hash" do
          @converter.body.should == []
        end

        it "should have a state followed by it's result" do
          @hash[:one] = { :transition1 => [:two] }

          @converter.body.should == [[:one, [:two]]]
        end

        it "should have a symbol with no values if none are present (a degenerative case)" do
          @hash[:one] = { :transition => [] }
          @converter.body.should == [[:one, []]]
        end

        it "should use empty arrays for symbols which do not exist (the empty set)" do
          @hash[:one] = { :t1 => [:two] }
          @hash[:two] = { :t2 => [:three] }

          @converter.body.should == [[:one, [:two], []], [:two, [], [:three]]]
        end

        it "should use multiple target states (for a NFA)" do
          @hash[:one] = { :t1 => [:two, :three]}

          @converter.body.should == [[:one, [:two, :three]]]
        end
      end

      describe "to_a" do
        it "should be empty with an empty hash" do
          @converter.to_a.should == []
        end

        it "should use the header and body" do
          @hash[:one] = { :two => [:three] }

          @converter.to_a.should == [["", :two], [[:one, [:three]]]]
        end
      end
    end
  end
end
