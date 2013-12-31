#!/usr/bin/env ruby

require_relative '../lib/environment'

Environment.new do |e|
  e.assert [:in, :box, :hall]

  e.rule(:move) do |r|
    r.conditions [:in, :@object, :hall]
    r.activations do |bindings|
      e.retract [:in, bindings[:@object], :hall]
      e.assert [:in, bindings[:@object], :garage]
    end
  end

  p e.facts.to_a #=> [[:in, :box, :hall]]
  e.step
  p e.facts.to_a #=> [[:in, :box, :garage]]
end
