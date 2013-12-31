class Match
  attr_reader :rule,:bindings

  def initialize(rule,bindings)
    @rule,@bindings = rule,bindings
  end

  def activate
    @rule.fire(@bindings)
  end
end
