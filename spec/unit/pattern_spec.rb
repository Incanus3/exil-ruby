require 'spec_helper'

describe Pattern do
  describe "#match" do
    let(:pattern)  { Pattern.new([:in,:@obj,:@loc]) }
    let(:pattern2) { Pattern.new([:in,:@obj,:@obj,:@loc]) }
    let(:fact)  { [:in,:box,:hall] }
    let(:fact2) { [:out,:box,:hall] }
    let(:fact3) { [:in,:box,:robot,:hall]}

    context "when the fact matches the pattern" do
      it 'returns variable bindings' do
        expect(pattern.match(fact)).to eq(Substitution.new({ :@obj => :box, :@loc => :hall }))
      end
    end

    context "when the fact doesn't match the pattern" do
      it 'returns nil' do
        expect(pattern.match(fact2)).to be nil
      end
    end

    context "when there are inconsistent variable bindigns" do
      it 'returns nil' do
        expect(pattern2.match(fact3)).to be nil
      end
    end
  end
end
