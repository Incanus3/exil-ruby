require 'spec_helper'

describe Condition do
  describe "#matches" do
    let(:facts) { [[:goal,:box,:hall],[:in,:box,:garage],[:in,:robot,:hall]] }
    let(:fact_holder) { double("fact_holder", facts: facts) }

    let(:cond1) { Condition.new(fact_holder, [:in,:_obj,:_loc]) }

    it 'returns all matching substitutions of variables' do
      expect(cond1.matches).to match_array [{ _obj: :box, _loc: :garage},
                                            { _obj: :robot, _loc: :hall}]
    end
  end
end
