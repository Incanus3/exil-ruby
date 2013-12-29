require 'set'
require_relative 'rules'

class Environment
  attr_writer :facts

  def facts
    @facts ||= Set.new
  end

  def assert(*facts)
    self.facts += facts
  end

  def retract(fact)
    self.facts.delete(fact)
  end

  #########################################################

  def rules
    @rules ||= Rules.new(self)
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
    unless rules.satisfied.empty?
      rules.satisfied.select.fire
    end
  end

  #########################################################

  def initialize(&block)
    if block_given?
      yield(self)
    end
  end
end
