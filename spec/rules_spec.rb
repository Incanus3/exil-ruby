require 'spec_helper'

describe Rules do
  let(:facts) { [[:goal,:box,:hall],[:in,:box,:garage],[:in,:robot,:hall]] }
  let(:fact_holder) { double("fact_holder", facts: facts) }
  let(:rules) { Rules.new(fact_holder) }

  describe "#matches" do
    before do
      rules.define(:move) do |r|
        # r.conditions [:goal,:_obj,:_loc],[:in,:_obj,:_somewhere]
        r.conditions [:in,:_obj,:_loc]
        r.activations {}
      end

      @rule = rules[:move]
    end

    it "returns correct matches" do
      # include and match_array probably test by identity
      # expect(rules.matches).to include Match.new(@rule, { _obj: :box, _loc: :garage })
      # expect(rules.matches).to match_array([Match.new(@rule, { _obj: :box, _loc: :garage }),
                                            # Match.new(@rule, { _obj: :robot, _loc: :hall })]) #, _somewhere: :garage })
      expect(rules.matches.find {|match|
        match.rule == @rule && match.bindings == { _obj: :box, _loc: :garage } }).to be
    end
  end
end
