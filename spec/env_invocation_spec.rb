require 'spec_helper'

describe Environment,'invocation' do
  let(:fact1) { "fact" }

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
