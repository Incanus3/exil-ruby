require 'spec_helper'

describe 'Conditions' do
  let(:facts) { [[:goal,:box,:hall],[:in,:box,:garage],[:in,:robot,:hall]] }

  describe EmptyCondition do
    let(:cond) { EmptyCondition.new }

    it '#matches ruturns one empty substitution' do
      expect(cond.matches(facts)).to eq [Substitution.new]
    end
  end

  describe SingleCondition do
    let(:cond) { SingleCondition.new([:in,:@obj,:@loc]) }

    it '#matches returns all matching substitutions of variables' do
      expect(cond.matches(facts)).to match_array [
        Substitution.new({ :@obj => :box, :@loc => :garage}),
        Substitution.new({ :@obj => :robot, :@loc => :hall})]
    end
  end

  describe AndCondition do
    let(:cond) { AndCondition.new(SingleCondition.new([:in,:@obj,:@loc]),
                                  SingleCondition.new([:in,:robot,:@robloc]))}

    it '#matches returns substituions matching all conditions' do
      expect(cond.matches(facts)).to match_array [
        Substitution.new({ :@obj => :box, :@loc => :garage, :@robloc => :hall }),
        Substitution.new({ :@obj => :robot, :@loc => :hall, :@robloc => :hall })]
    end
  end

  describe OrCondition do
    let(:cond) { OrCondition.new(SingleCondition.new([:in,:@obj,:hall]),
                                 SingleCondition.new([:in,:@obj,:garage]))}

    it '#matches returns substituions matching any of the conditions' do
      expect(cond.matches(facts)).to match_array [
        Substitution.new({ :@obj => :box }),
        Substitution.new({ :@obj => :robot })]
    end
  end
end
