# What?
This is a proof of concept rewrite of my Expert System in Lisp project in Ruby

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
    r.conditions [:in,:@object,:@loc],[:in,:robot,:@loc]
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

Environment.new do |e|
  e.assert [:in, :box, :hall],[:in, :robot1, :garage],[:in, :robot2, :hall]

  e.rule(:move) do |r|
    r.conditions do |c|
      c.and([:in,:box,:@loc],
            c.or([:in,:robot1,:@loc],[:in,:robot2,:@loc]))
    end
    r.activations do
      e.retract [:in, :box, @loc]
      e.assert [:in, :box, :garage]
    end
  end

  p e.facts #>> [:in, :box, :hall],[:in, :robot1, :garage],[:in, :robot2, :hall]
  e.step    #>> firing rule MOVE with bindings {:@loc=>:hall}
  p e.facts #>> [:in, :box, :garage],[:in, :robot1, :garage],[:in, :robot2, :hall]
end
```

The expert system domain is a great candidate for DSL, we could even get rid of the
e and r helpers using instance_eval, but this would mean evaluating the block in
a different context, thus preventing the usage of local functions defined in the
surrounding lexical environment

Tested on Ruby 2.1, but should work fine on 1.9+

## What's supported
- facts and patterns can be either simple atoms (tested by ==) or any composite
  object implementing length and each (tested recursively)
- variables are symbols starting with @, these are bound in rule's activations
  as instance variables
- and, or conditions are supported now, see inference integration spec
