require_relative 'condition'

class ConditionBuilder
  def self.build(*conditions)
    if block_given?
      # ignore list for now
      yield(self)
    else
      build_from_list(conditions)
    end
  end

  def self.empty
    EmptyCondition.new
  end

  def self.single(condition)
    if condition.is_a?(Condition)
      condition
    else
      SingleCondition.new(condition)
    end
  end

  def self.and(*conditions)
    AndCondition.new(*conditions.map {|cond| build(cond)})
  end

  def self.or(*conditions)
    OrCondition.new(*conditions.map {|cond| build(cond)})
  end

  private

  def self.build_from_list(conditions)
    case conditions.size
    when 0
      self.empty
    when 1
      self.single(conditions.first)
    else
      self.and(*conditions)
    end
  end
end
