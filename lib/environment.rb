require 'set'
require_relative 'rules'

# stores asserted facts and defined rules
# handles inference
class Environment
  def initialize(&block)
    @facts = Set.new
    if block_given?
      yield(self)
    end
  end

  #########################################################

  def facts
    @facts.to_a
  end

  def assert(*facts)
    @facts += facts
  end

  def retract(fact)
    @facts.delete(fact)
  end

  #########################################################

  def rules
    @rules ||= Rules.new
  end

  # without block works as finder
  def rule(name,&block)
    if block_given?
      rules.define(name,&block)
    else
      rules[name]
    end
  end

  #########################################################

  def step
    # matches could be stored in dedicated collection object, that would handle
    # their selection (strategies), timestamping, etc.
    matches = rules.matches(facts)
    matches.first.activate unless matches.empty?
  end
end
