require 'rails_helper'

shared_examples_for 'broadcastable' do
  klass_name = described_class.name.downcase
  let(:object) { build(klass_name) }

  it 'broadcasts object after create' do
    expect(object).to receive("broadcast_new_#{klass_name}")
    object.save!
  end
end
