require 'rails_helper'

RSpec.shared_examples 'broadcastable' do
  klass_name = described_class.name.downcase
  let(:object) { build(klass_name) }

  it 'broadcasts object after create' do
    expect(object).to receive("broadcast_new_#{klass_name}")
    object.save!
  end
end
