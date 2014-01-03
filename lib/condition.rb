require_relative 'pattern'

# Conditions provide matching with a list of facts

class Condition
  def matches(facts)
    raise 'all conditions must implement #matches(facts)'
  end
end

class EmptyCondition < Condition
  def matches(facts)
    [Substitution.new]
  end
end

class SingleCondition < Condition
  attr_reader :pattern

  def initialize(pattern)
    @pattern = Pattern.new(pattern)
  end

  # returns list of possible bindings as Substitutions
  def matches(facts)
    (facts.map { |fact| pattern.match(fact) } - [nil]).uniq
  end
end

class AndCondition < Condition
  def initialize(*conditions)
    @conditions = conditions
  end

  def matches(facts)
    matches = @conditions.map { |c| c.matches(facts) }
      .reduce { |acc,matches| compose(acc,matches) }
  end

  private

  # composes two lists of substitutions in all possible combinations
  def compose(matches1,matches2)
    matches1.map do |subst1|
      matches = matches2.map do |subst2|
        subst1.compose(subst2)
      end
    end.reduce(:+) - [nil]
  end
end

class OrCondition < Condition
  def initialize(*conditions)
    @conditions = conditions
  end

  def matches(facts)
    matches = @conditions.map { |c| c.matches(facts) }.reduce(:+)
  end
end
