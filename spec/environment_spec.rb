require 'spec_helper'

describe Environment do
  subject(:env) { Environment.new }

  let(:fact1) { "fact" }
  let(:fact2) {[:in, :box, :hall]}

  context 'facts' do
    context 'assertion' do
      it "adds fact to facts" do
        env.assert(fact1)

        expect(env.facts).to include fact1
      end
    end

    context 'retraction' do
      it "removes fact from facts" do
        env.assert(fact1)
        env.assert(fact2)

        expect(env.facts).to include fact1
        expect(env.facts).to include fact2

        env.retract(fact1)

        expect(env.facts).not_to include fact1
        expect(env.facts).to include fact2
      end
    end
  end

  context 'rules' do
    it 'definition' do
      env.rule(:test) {}

      expect(env.rule(:test)).to be_a Rule
    end

    context 'satisfaction' do
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

    context 'inference' do
      it 'works' do
        activated = false

        env.assert(:test)

        env.rule(:test) do |r|
          r.conditions :test
          r.activations do
            env.assert(:activated)
          end
        end

        # expect(activated).to be_false
        expect(env.facts).not_to include :activated
        env.step
        # expect(activated).to be_true
        expect(env.facts).to include :activated
      end
    end
  end
end
