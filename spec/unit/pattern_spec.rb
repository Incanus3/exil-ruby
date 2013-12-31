require 'spec_helper'

describe Pattern do
  describe "#match" do
    let(:pattern)  { Pattern.new([:in,:_obj,:_loc]) }
    let(:pattern2) { Pattern.new([:in,:_obj,:_obj,:_loc]) }
    let(:fact)  { [:in,:box,:hall] }
    let(:fact2) { [:out,:box,:hall] }
    let(:fact3) { [:in,:box,:robot,:hall]}

    context "when the fact matches the pattern" do
      it 'returns variable bindings' do
        expect(pattern.match(fact)).to eq({ _obj: :box, _loc: :hall })
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
