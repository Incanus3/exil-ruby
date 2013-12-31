require_relative 'pattern'

# Condition provides matching with a list of facts
# subclasses could provide negation and aggregation of several conditions
class Condition
  attr_reader :pattern

  def initialize(pattern)
    @pattern = Pattern.new(pattern)
  end

  # returns list of possible bindings as Substitutions
  def matches(facts)
    (facts.map { |fact| pattern.match(fact) } - [nil]).uniq
  end
end
