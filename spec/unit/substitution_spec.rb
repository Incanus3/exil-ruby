require 'spec_helper'

describe Substitution do
  let(:subst1) { Substitution.new({}) }
  let(:subst2) { Substitution.new({:@obj=>:robot, :@loc=>:hall}) }

  it 'composes them' do
    expect(subst1.compose(subst2)).to eq Substitution.new({:@obj=>:robot, :@loc=>:hall})
  end
end
