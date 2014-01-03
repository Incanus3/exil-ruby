require_relative 'condition_builder'

# this provides a context in which Rule's activations are evaluated
# .new takes bindings hash and binds instance variables in keys to values
class Context
  def variable?(var)
    var.respond_to?(:to_s) && var.to_s[0] == '@'
  end

  def initialize(bindings)
    bindings.each do |var,val|
      instance_variable_set(var,val) if variable?(var)
    end
  end
end

# Rule stores a condition (which may be composite) and an activations block
# it can provide a list of possible matches (variable Substitutions) when given
# list of facts, computing the matches is not its responsibility - it asks the
# condition
# it can fire itself (evaluate the activations block in context with variable
# bindings) when given variable Substitution
class Rule
  attr_reader :name

  def initialize(name,&block)
    raise 'Rule.new must get a block' unless block_given?
    @name = name
    block.call(self)
  end

  def conditions(*conds,&block)
    # ConditionBuilder.build returns one condition, which may be composite (and,
    # or), depending on number of conditions or the block given
    @condition = ConditionBuilder.build(*conds,&block)
  end

  # this could possibly be called multiple times and store blocks in a list
  def activations(&block)
    @activations = block
  end

  def fire(bindings)
    puts "firing rule #{name.upcase} with bindings #{bindings.inspect}"
    Context.new(bindings).instance_eval(&@activations)
  end

  # returns list of matches (variable Substitution) of conditions with given
  # facts
  def matches(facts)
    @condition.matches(facts)
  end
end
