#!/usr/bin/env ruby

require_relative '../lib/environment'

Environment.new do |e|
  e.assert [:in, :box, :hall]

  e.rule(:move) do |r|
    r.conditions [:in, :@object, :hall]
    r.activations do
      e.retract [:in, @object, :hall]
      e.assert [:in, @object, :garage]
    end
  end

  p e.facts #=> [[:in, :box, :hall]]
  e.step
  p e.facts #=> [[:in, :box, :garage]]
end
