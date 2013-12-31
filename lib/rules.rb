require_relative 'rule'
require_relative 'match'

# encapsulates rule collection accessible by name
# can compute matches for all stored rules
class Rules
  attr_reader :rules

  def initialize(rules = {})
    @rules = rules
  end

  def define(name,&block)
    rules[name] = Rule.new(name,&block)
  end

  # returns list of Matches for all rules with given facts
  def matches(facts)
    rules.values.map {|rule|
      rule.matches(facts).map { |bindings| Match.new(rule,bindings) }
    }.reduce(:+).uniq
  end

  # delegate all unknown methods to the actual collection
  def method_missing(name,*args,&block)
    # NoMethodError should be raised on this object
    super unless rules.respond_to?(name)
    rules.send(name,*args,&block)
  end

  def respond_to_missing?(name)
    super || rules.respond_to?(name)
  end
end
