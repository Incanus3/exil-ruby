require 'spec_helper'

describe Environment do
  include_context 'basic resources'

  context 'invocation' do
    context 'explicit environment' do
      it "works" do
        env = Environment.new

        env.assert(fact1)

        expect(env.facts).to include fact1
      end
    end

    context 'yielded environment' do
      it "works" do
        Environment.new do |e|
          e.assert(fact1)

          expect(e.facts).to include fact1
        end
      end
    end
  end

  context "rules definition" do
    it "works" do
      env.rule(:test) {}

      expect(env.rule(:test)).to be_a Rule
    end
  end

  context 'facts manipulation' do
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
end
