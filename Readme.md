# What?
This is a proof of concept rewrite of my Expert System in Lisp project

See https://github.com/Incanus3/dipl-ruby/blob/master/spec/integration/inference_spec.rb for what it can do.

# Why?
1. It's hard to implement composite conditions in ExiL rules, because of the
   RETE algorithm it uses
2. It's hard to do a good object design in Lisp because of its package system
   and the way methods work (all methods with the same name, albeit for
   different objects, must have congruent argument list)
3. In ruby, it's possible to bend the language to the needs of the project - to
   create new, domain-specific constructs. Lisp's macros allow this too (and are
   much more powerful), but more complex macros are hard to write and thus
   error-prone

## Example
```ruby
Environment.new do |e|
  e.assert [:in, :box, :hall]

  e.rule(:move) do |r|
    r.conditions [:in, :@object, :hall]
    r.activations do
      e.retract [:in, @object, :hall]
      e.assert [:in, @object, :garage]
    end
  end

  p e.facts #>> [[:in, :box, :hall]]
  e.step    #>> "Firing rule MOVE with bindings {:@object=>:box}"
  p e.facts #>> [[:in, :box, :garage]]
end
```
