require_relative 'rule'

# encapsulates rule collection accessible by name, can provide interesting
# accessors in future
class Rules
  attr_reader :rules,:fact_holder

  def initialize(fact_holder,rules = {})
    @rules = rules
    @fact_holder = fact_holder
  end

  # rules need access to the fact holder to provide it to each rule
  def define(name,&block)
    rules[name] = Rule.new(fact_holder,&block)
  end

  # returns new rule collection so we can chain method calls
  def satisfied
    Rules.new(fact_holder,rules.values.select(&:satisfied?))
  end

  def select
    rules.first
  end

  # delegate all unknown methods to the actual collection
  def method_missing(*args,&block)
    rules.send(*args,&block)
  end

  def respond_to?(name)
    super || rules.respond_to?(name)
  end
end
