require 'spec_helper'

describe Rules do
  let(:facts) { [[:goal,:box,:hall],[:in,:box,:garage],[:in,:robot,:hall]] }
  # let(:fact_holder) { double("fact_holder", facts: facts) }
  let(:rules) { Rules.new }

  describe "#matches" do
    before do
      rules.define(:move) do |r|
        r.conditions [:in,:@obj,:@loc]
        r.activations {}
      end

      @rule = rules[:move]
    end

    it "returns correct matches" do
      expect(rules.matches(facts)).to match_array([
        Match.new(@rule, Substitution.new({ :@obj => :box, :@loc => :garage })),
        Match.new(@rule, Substitution.new({ :@obj => :robot, :@loc => :hall }))])
    end
  end
end
