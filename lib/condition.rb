require_relative 'pattern'

# Conditions provide matching with a list of facts

class EmptyCondition
  def matches(facts)
    [Substitution.new]
  end
end

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

class AndCondition
  def initialize(*conditions)
    @conditions = conditions
  end

  # composes two lists of substitutions in all possible combinations
  def compose(matches1,matches2)
    matches = matches1.map do |subst1|
      matches = matches2.map do |subst2|
        subst1.compose(subst2)
      end
    end
    matches.delete(nil)
    matches.reduce(:+)
  end

  def matches(facts)
    @conditions.map { |c| c.matches(facts) }
      .reduce { |acc,matches| compose(acc,matches) }
  end
end

class OrCondition
  def initialize(*conditions)
    @conditions = conditions
  end

  def matches(facts)
    []
  end
end
