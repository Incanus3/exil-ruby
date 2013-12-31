require_relative 'rule'
require_relative 'match'

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

  def matches
    # Rule#matches retruns list of possible variable bindings
    rules.values.map {|rule|
      rule.matches.map { |bindings| Match.new(rule,bindings) }
    }.reduce(:+).uniq
  end

  def select
    rules.first
  end

  # delegate all unknown methods to the actual collection
  def method_missing(name,*args,&block)
    # NoMethodError should be raised on this object
    super unless rules.respond_to?(name)
    rules.send(name,*args,&block)
  end

  def respond_to?(name)
    super || rules.respond_to?(name)
  end
end
