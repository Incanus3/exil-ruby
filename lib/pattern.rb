# pattern should provide matching with single fact
class Pattern
  attr_reader :pattern

  def initialize(pattern)
    @pattern = pattern
  end

  def matches?(fact)
    # puts "========="
    match(fact,pattern)
  end

  private

  def collection?(obj)
    obj.respond_to?(:each) && obj.respond_to?(:size)
  end

  def variable?(atom)
    atom.respond_to?(:to_s) && atom.to_s[0] == '_'
  end

  def match_collection(fact,pattern)
    if fact.size == pattern.size
      fact.zip(pattern).map {|f,p| match(f,p)}.reduce {|acc,match| acc && match }
    end
  end

  def match_atom(fact,pattern)
    if variable?(pattern)
      true
    else
      fact == pattern
    end
  end

  def match(fact,pattern)
    # puts "matching #{fact} and #{pattern}"
    if collection?(fact) && collection?(pattern)
      match_collection(fact,pattern)
    elsif !collection?(fact) && !collection?(pattern)
      match_atom(fact,pattern)
    end
  end
end
