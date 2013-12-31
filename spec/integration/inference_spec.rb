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

  it 'assigns variables' do
    env.assert [:in, :box, :hall]

    env.rule(:move) do |r|
      r.conditions [:in, :_object, :hall]
      r.activations do |bindings|
        env.retract [:in, bindings[:_object], :hall]
        env.assert [:in, bindings[:_object], :garage]
      end
    end

    expect(env.facts).not_to include [:in,:box,:garage]
    env.step
    expect(env.facts).to include [:in,:box,:garage]
    expect(env.facts).not_to include [:in,:box,:hall]
  end
end
