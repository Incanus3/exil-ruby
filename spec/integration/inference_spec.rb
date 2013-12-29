require 'spec_helper'

describe 'inference' do
  include_context 'basic resources'

  it 'works' do
    env.assert(:test)

    env.rule(:test) do |r|
      r.conditions :test
      r.activations do
        env.assert(:activated)
      end
    end

    expect(env.facts).not_to include :activated
    env.step
    expect(env.facts).to include :activated
  end
end
