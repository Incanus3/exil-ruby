require 'spec_helper'

describe Rule do
  let(:facts) { [[:goal,:box,:hall],[:in,:box,:garage],[:in,:robot,:hall]] }
  let(:fact_holder) { double("fact_holder", facts: facts) }
  describe "#matches" do
    let(:rule) do
      rule = Rule.new(fact_holder) do |r|
        # r.conditions [:goal,:_obj,:_loc],[:in,:_obj,:_somewhere]
        r.conditions [:in,:_obj,:_loc]
        r.activations {}
      end
    end

    it "returns correct matches" do
      expect(rule.matches).to match_array([{ _obj: :box, _loc: :garage },
                                           { _obj: :robot, _loc: :hall }]) #, _somewhere: :garage })
    end
  end
end
