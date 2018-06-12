require 'simplecov'

RSpec.configure do |c|
  c.filter_run focus: true
  c.filter_run_excluding disabled: true
  c.run_all_when_everything_filtered = true
end

SimpleCov.start do
  add_filter "/spec/"
end

SimpleCov.at_exit do
  SimpleCov.result.format!
  SimpleCov.minimum_coverage 97
  SimpleCov.refuse_coverage_drop
end

require 'environment'
