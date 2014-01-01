require 'spec_helper'

describe Rule do
  let(:facts) { [[:goal,:box,:hall],[:in,:box,:garage],[:in,:robot,:hall]] }

  describe "#matches" do
    context "with no conditions" do
      let(:rule) do
        Rule.new(:test) do |r|
          r.conditions
          r.activations {}
        end
      end

      it "returns no matches" do
        expect(rule.matches(facts)).to match_array([Substitution.new])
      end
    end

    context "with single condition" do
      context "given directly" do
        let(:rule) do
          Rule.new(:test) do |r|
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

      context "given by block" do
        let(:rule) do
          Rule.new(:test) do |r|
            r.conditions {|c| c.single [:in,:@obj,:@loc]}
            r.activations {}
          end
        end

        it "returns correct matches" do
          expect(rule.matches(facts)).to match_array([
            Substitution.new({ :@obj => :box, :@loc => :garage }),
            Substitution.new({ :@obj => :robot, :@loc => :hall })])
        end
      end
    end

    context "with multiple conditions" do
      context "given by list",:disabled do
        let(:rule) do
          Rule.new(:test) do |r|
            r.conditions [:in,:@object,:garage], [:in,:robot,:hall]
            r.activations {}
          end
        end

        it "returns correct matches" do
          expect(rule.matches(facts)).to match_array([
            Substitution.new({ :@obj => :box, :@loc => :garage }),
            Substitution.new({ :@obj => :robot, :@loc => :hall })])
        end
      end

      context "given by block",:disabled do
        let(:rule) do
          Rule.new(:test) do |r|
            r.conditions do |c|
              c.and([:in,:@object,:garage],
                    c.or([:in,:robot,:hall],[:in,:robot,:outside]))
            end
            r.activations {}
          end
        end

        it "returns correct matches" do
          expect(rule.matches(facts)).to match_array([
            Substitution.new({ :@obj => :box, :@loc => :garage }),
            Substitution.new({ :@obj => :robot, :@loc => :hall })])
        end
      end
    end
  end

  describe "#fire" do
    let(:bindings) { Substitution.new({ :@object => :box, :@location => :hall}) }

    it "evaluates activation in context with bound variables" do
      test = nil
      rule = Rule.new(:test) do |r|
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
