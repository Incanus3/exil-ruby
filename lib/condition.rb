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

  def matches(facts)
    @conditions.reduce([Substitution.new]) do |acc,cond|
      # puts "reduce, acc = #{acc}, cond = #{cond}"
      acc.map do |subst1|
        # puts "outer loop, subst1 = #{subst1}"
        matches1 = cond.matches(facts)
        # puts "matches1 = #{matches1}"
        matches = matches1.map do |subst2|
          # puts "inner loop, subst2 = #{subst2}"
          subst1.compose(subst2)
        end
        matches.delete(nil)
        # puts "matches = #{matches}"
        matches
      end.reduce(:+)
    end
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
