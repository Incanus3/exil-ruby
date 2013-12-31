require 'spec_helper'

describe Rule do
  let(:facts) { [[:goal,:box,:hall],[:in,:box,:garage],[:in,:robot,:hall]] }

  describe "#matches" do
    let(:rule) do
      rule = Rule.new do |r|
        r.conditions [:in,:@obj,:@loc]
        r.activations {}
      end
    end

    it "returns correct matches" do
      expect(rule.matches(facts)).to match_array([
        Substitution.new({ :@obj => :box, :@loc => :garage }),
        Substitution.new({ :@obj => :robot, :@loc => :hall })])
    end
  end
end
