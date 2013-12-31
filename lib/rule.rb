require_relative 'condition'

# Rule has conditions and activations
# it can provide a list of possible matches (variable Substitutions) when given
# list of facts
# it can fire itself (evaluate the activations) when given variable Substitution
class Rule
  def initialize(&block)
    raise 'Rule.new must get a block' unless block_given?
    block.call(self)
  end

  # @conditions is now array and this takes multiple ones, but in the future,
  # either single condition should be defined or agregation functions should be
  # used
  # - conditions should yield a condition builder object
  # - condition builder defines 'and', 'or' methods, which return
  #   AndCondition.new(conditions), OrCondition, etc.
  # - AndCondition will subclass CollectionAggregation, which stores list of
  #   conditions and aggregates their satisfaction values
  def conditions(*conds)
    if conds.empty?
      @conditions ||= []
    else
      @conditions = conds.map {|cond| Condition.new(cond)}
    end
  end

  # this could possibly be called multiple times and store blocks in a list
  def activations(&block)
    @activations = block
  end

  def fire(bindings)
    @activations.call(bindings)
  end

  # returns list of matches (variable Substitution) of conditions with given
  # facts
  def matches(facts)
    # get list of matches for each condition - these are variable substitutions
    # find combinations of substitutions (one for each condition) with
    # consistent variable bindings and compose them
    # FOR NOW, THIS ONLY CONCATENATES THE LISTS OF MATCHINGS FOR EACH CONDITION
    # SO THIS ONLY MAKES SENSE WITH ONE CONDITION
    #
    # each condition.matches returns list of hashes, so this is a 2d list - one
    # list of possible matches for each condition
    matches = conditions.map {|cond| cond.matches(facts) }
    matches.reduce(:+)
  end
end
