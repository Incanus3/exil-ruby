require 'spec_helper'

describe 'rules',:disabled do
  include_context 'basic resources'

  context 'satisfaction' do
    context "simple facts" do
      it "is satisfied when fact present" do
        env.assert(:test)

        env.rule(:test) do |r|
          r.conditions :test
          r.activations {}
        end

        expect(env.rule(:test)).to be_satisfied
      end

      it "isn't satisfied when fact not present" do
        env.rule(:test) do |r|
          r.conditions :test
          r.activations {}
        end

        expect(env.rule(:test)).not_to be_satisfied
      end
    end

    context "facts with variables" do
      it "works" do
        env.assert [:in, :box, :hall]

        env.rule(:move) do |r|
          r.conditions [:in, :_object, :hall]
          r.activations {}
        end

        expect(env.rule(:move)).to be_satisfied
      end
    end

    context "multiple conditions" do
      before do
        env.rule(:test) do |r|
          r.conditions fact1,fact2
          # r.conditions do |c|
          #   c.and(c.single(fact1),c.single(fact2))
          #   # ideally convert non-conditions to conditions automatically:
          #   # c.and(fact1,fact2)
          #   # this could maybe even use instance_eval - if there's no need to
          #   # call functions from lexical scope
          # end
        end
      end

      it "is satisfied when all conditions satisfied" do
        env.assert(fact1,fact2)
        expect(env.rule(:test)).to be_satisfied
      end

      it "isn't satisfied when one condition failed" do
        env.assert(fact1)
        expect(env.rule(:test)).not_to be_satisfied
      end
    end
  end
end
