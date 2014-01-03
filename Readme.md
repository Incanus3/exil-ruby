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
  e.assert [:in, :box, :hall],[:in, :robot, :hall]

  e.rule(:move) do |r|
    r.conditions do |c|
      c.and([:in,:@object,:@loc],[:in,:robot,:@loc])
    end
    r.activations do
      e.retract [:in, @object, @loc]
      e.assert [:in, @object, :garage]
      e.retract [:in, :robot, @loc]
      e.assert [:in, :robot, :garage]
    end
  end

  p e.facts #>> [[:in, :box, :hall], [:in, :robot, :hall]]
  e.step    #>> "Firing rule MOVE with bindings {:@object=>:box, :@loc=>:hall}"
  p e.facts #>> [[:in, :box, :garage], [:in, :robot, :garage]]
end
```

The expert system domain is a great candidate for DSL, we could even get rid of the
e and r helpers using instance_eval, but this would mean evaluating the block in
a different context, thus preventing the usage of local functions defined in the
surrounding lexical environment

## What's supported
- facts and patterns can be either simple atoms (tested by ==) or any composite
  object implementing length and each (tested recursively)
- variables are symbols starting with @, these are bound in rule's activations
  as instance variables
- and, or conditions are supported now, see inference integration spec
