require_relative 'substitution'

# Pattern provides matching with single fact
# patterns and facts may be composite, Pattern matches them recursively
class Pattern
  def initialize(pattern)
    @pattern = pattern
  end

  # returns variable bindings as Substitution or nil when they don't match
  def match(fact)
    _match(pattern,fact)
  end

  private

  attr_reader :pattern

  def collection?(obj)
    obj.respond_to?(:each) && obj.respond_to?(:size)
  end

  def variable?(atom)
    atom.respond_to?(:to_s) && atom.to_s[0] == '@'
  end

  def match_collection(pattern,fact)
    if fact.size == pattern.size
      bindings = pattern.zip(fact).map {|p,f| _match(p,f)}
      Substitution.compose(*bindings) unless bindings.include?(nil)
    end
  end

  def match_atom(pattern,fact)
    if variable?(pattern)
      Substitution.new({ pattern => fact })
    elsif fact == pattern
      Substitution.new({})
    end
  end

  def _match(pattern,fact)
    if collection?(fact) && collection?(pattern)
      match_collection(pattern,fact)
    elsif !collection?(fact) && !collection?(pattern)
      match_atom(pattern,fact)
    end
  end
end
