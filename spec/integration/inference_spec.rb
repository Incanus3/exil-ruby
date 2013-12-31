require 'spec_helper'

describe 'inference' do
  it 'works' do
    Environment.new do |e|
      e.assert(:test)

      e.rule(:test) do |r|
        r.conditions :test
        r.activations do
          e.assert(:activated)
        end
      end

      expect(e.facts).not_to include :activated
      e.step
      expect(e.facts).to include :activated
    end
  end

  it 'assigns variables' do
    Environment.new do |e|
      e.assert [:in, :box, :hall]

      e.rule(:move) do |r|
        r.conditions [:in, :@object, :hall]
        r.activations do |bindings|
          e.retract [:in, bindings[:@object], :hall]
          e.assert [:in, bindings[:@object], :garage]
        end
      end

      expect(e.facts).to include [:in,:box,:hall]
      expect(e.facts).not_to include [:in,:box,:garage]

      e.step

      expect(e.facts).not_to include [:in,:box,:hall]
      expect(e.facts).to include [:in,:box,:garage]
    end
  end
end
