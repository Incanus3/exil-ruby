class Substitution
  def initialize(subst)
    @subst = subst
  end

  def compose(other)
    result = self.subst
    other.subst.each do |(var,val)|
      if result[var]
        return nil if result[var] != val
      else
        result[var] = val
      end
    end
    self.class.new result
  end

  def ==(other)
    self.subst == other.subst if other && other.is_a?(self.class)
  end

  def [](index)
    @subst[index]
  end

  protected

  attr_reader :subst
end
