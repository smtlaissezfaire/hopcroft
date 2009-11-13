require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Machine
    describe TransitionTable do
      before do
        @table = TransitionTable.new
      end

      it "should raise a NotImplementedError when calling add_state_change" do
        lambda {
          @table.add_state_change :from, :to, :sym
        }.should raise_error(NotImplementedError)
      end

      it "should raise a NotImplementedError when calling matches?" do
        lambda {
          @table.matches?([])
        }.should raise_error(NotImplementedError)
      end
    end
  end
end
