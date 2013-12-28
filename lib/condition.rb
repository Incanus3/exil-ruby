require_relative 'pattern'

# condition should provide matching with facts_holder, negation and aggregation
class Condition
  attr_reader :pattern
  attr_reader :fact_holder

  def initialize(fact_holder,pattern)
    @fact_holder = fact_holder
    @pattern = Pattern.new(pattern)
  end

  def satisfied?
    fact_holder.facts.any? { |fact| pattern.matches?(fact) }
  end
end
