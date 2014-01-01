require 'spec_helper'

describe SingleCondition do
  describe "#matches" do
    let(:facts) { [[:goal,:box,:hall],[:in,:box,:garage],[:in,:robot,:hall]] }

    let(:cond1) { SingleCondition.new([:in,:@obj,:@loc]) }

    it 'returns all matching substitutions of variables' do
      expect(cond1.matches(facts)).to match_array [
        Substitution.new({ :@obj => :box, :@loc => :garage}),
        Substitution.new({ :@obj => :robot, :@loc => :hall})]
    end
  end
end
