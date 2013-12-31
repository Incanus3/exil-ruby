require 'spec_helper'

describe Rule do
  let(:facts) { [[:goal,:box,:hall],[:in,:box,:garage],[:in,:robot,:hall]] }

  describe "#matches" do
    let(:rule) do
      rule = Rule.new do |r|
        r.conditions [:in,:@obj,:@loc]
        r.activations {}
      end
    end

    it "returns correct matches" do
      expect(rule.matches(facts)).to match_array([
        Substitution.new({ :@obj => :box, :@loc => :garage }),
        Substitution.new({ :@obj => :robot, :@loc => :hall })])
    end
  end

  describe "#fire" do
    let(:bindings) { Substitution.new({ :@object => :box, :@location => :hall}) }

    it "evaluates activation in context with bound variables" do
      test = nil
      rule = Rule.new do |r|
        r.conditions []
        r.activations { test = @object }
      end

      rule.fire(bindings)
      expect(test).to eq :box
    end
  end
end

describe Context do
  let(:bindings) { Substitution.new({ :@object => :box, :@location => :hall}) }
  subject(:context) { Context.new(bindings) }

  it 'binds variables' do
    expect(context.send(:instance_variable_get,:@object)).to eq :box
  end
end
