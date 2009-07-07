require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Machine
    describe EpsilonTransition do
      before do
        @to = mock(State)
        @transition = EpsilonTransition.new(@to)
      end

      it "should be a kind_of? Transition" do
        @transition.should be_a_kind_of(Transition)
      end

      it "should have a unique transition symbol (it should not be a symbol)" do
        @transition.symbol.class.should_not == Symbol
      end

      it "should not have nil as the symbol" do
        @transition.symbol.should_not be_nil
      end
    end
  end
end
