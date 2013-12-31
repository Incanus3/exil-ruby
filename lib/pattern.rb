require 'substitution'

# pattern should provide matching with single fact
class Pattern
  attr_reader :pattern

  def initialize(pattern)
    @pattern = pattern
  end

  def match(fact)
    _match(pattern,fact)
  end

  private

  def collection?(obj)
    obj.respond_to?(:each) && obj.respond_to?(:size)
  end

  def variable?(atom)
    atom.respond_to?(:to_s) && atom.to_s[0] == '_'
  end

  def match_collection(pattern,fact)
    if fact.size == pattern.size
      bindings = fact.zip(pattern).map {|f,p| _match(p,f)}
      unless bindings.include?(nil)
        bindings.reduce {|acc,binding|
          acc.compose(binding) if acc }
      end
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
