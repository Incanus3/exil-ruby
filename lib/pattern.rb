# pattern should provide matching with single fact
class Pattern
  attr_reader :pattern

  def initialize(pattern)
    @pattern = pattern
  end

  def matches?(fact)
    fact == pattern
  end
end
