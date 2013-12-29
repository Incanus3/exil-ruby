require 'environment'

RSpec.configure do |c|
  c.filter_run focus: true
  c.run_all_when_everything_filtered = true
  c.treat_symbols_as_metadata_keys_with_true_values = true
end

shared_context 'basic resources' do
  subject(:env) { Environment.new }

  let(:fact1) { "fact" }
  let(:fact2) {[:in, :box, :hall]}
end
