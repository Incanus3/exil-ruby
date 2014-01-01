require_relative 'pattern'

# Condition provides matching with a list of facts
# subclasses could provide negation and aggregation of several conditions
class SingleCondition
  attr_reader :pattern

  def initialize(pattern)
    @pattern = Pattern.new(pattern)
  end

  # returns list of possible bindings as Substitutions
  def matches(facts)
    (facts.map { |fact| pattern.match(fact) } - [nil]).uniq
  end
end

class EmptyCondition
  def matches(facts)
    [Substitution.new]
  end
end

class AndCondition
  def initialize(conditions)
    @conditions = conditions
  end

  def matches(facts)
    []
  end
end

class OrCondition
  def initialize(conditions)
    @conditions = conditions
  end

  def matches(facts)
    []
  end
end

class ConditionBuilder
  def self.build(*conditions)
    if block_given?
      # ignore list for now
      yield(self)
    else
      build_from_list(conditions)
    end
  end

  def self.single(condition)
      SingleCondition.new(condition)
  end

  def self.and(*conditions)
    AndCondition.new(conditions.map {|cond| build(cond)})
  end

  def self.or(*conditions)
    OrCondition.new(conditions.map {|cond| build(cond)})
  end

  private

  def self.build_from_list(conditions)
    case conditions.size
    when 0
      EmptyCondition.new
    when 1
      single(conditions[0])
    else
      self.and(*conditions)
    end
  end
end
