require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module Hopcroft
  module Regex
    describe Dot do
      it "should accept any one char" do
        pending 'FIXME' do
          d = Dot.new
          d.matches?("a").should be_true
        end
      end

      it "should not accept 0 chars" do
        d = Dot.new
        d.matches?("").should be_false
      end
    end
  end
end
