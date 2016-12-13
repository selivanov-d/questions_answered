require 'rails_helper'

RSpec.shared_examples 'attachable' do
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for(:attachments).allow_destroy(true) }
end
