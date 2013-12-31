class Match
  attr_reader :rule,:bindings

  def initialize(rule,bindings)
    @rule,@bindings = rule,bindings
  end

  def activate
    @rule.fire(@bindings)
  end

  def ==(other)
    rule == other.rule && bindings == other.bindings
  end
end
