# wraps substitution hash and provides substitution composition
class Substitution
  def initialize(subst = {})
    @subst = subst
  end

  def compose(other)
    result = self.subst.dup
    other.subst.each do |(var,val)|
      if result[var]
        return nil if result[var] != val
      else
        result[var] = val
      end
    end
    self.class.new result
  end

  def self.compose(*substitutions)
    substitutions.reduce {|acc,subst|
      acc.compose(subst) if acc }
  end

  def ==(other)
    self.subst == other.subst if other.respond_to?(:subst,true)
  end

  def inspect
    @subst.inspect
  end

  def to_s
    @subst.to_s
  end

  # forward all unknown messages to the subst hash
  def method_missing(name,*args,&block)
    subst.send(name,*args,&block)
  end

  def respond_to_missing?(name,all = false)
    super || subst.respond_to?(name)
  end

  protected

  attr_reader :subst
end
