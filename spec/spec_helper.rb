require 'environment'

shared_context 'basic resources' do
  subject(:env) { Environment.new }

  let(:fact1) { "fact" }
  let(:fact2) {[:in, :box, :hall]}
end
