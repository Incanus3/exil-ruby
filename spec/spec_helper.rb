require 'environment'

RSpec.configure do |c|
  c.filter_run focus: true
  c.filter_run_excluding disabled: true
  c.run_all_when_everything_filtered = true
  c.treat_symbols_as_metadata_keys_with_true_values = true
end
