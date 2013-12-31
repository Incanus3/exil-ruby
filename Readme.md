# What?
This is a proof of concept rewrite of my Expert System in Lisp project

See https://github.com/Incanus3/dipl-ruby/blob/master/spec/integration/inference_spec.rb for what it can do.

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

  p e.facts.to_a #=> [[:in, :box, :hall]]
  e.step
  p e.facts.to_a #=> [[:in, :box, :garage]]
end
```
