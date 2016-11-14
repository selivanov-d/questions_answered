require 'rails_helper'
require 'shared_examples/models/votable_spec'

RSpec.describe Question do
  it_should_behave_like 'votable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for(:attachments).allow_destroy(true) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :content }
  it { should validate_length_of(:title).is_at_least(10).is_at_most(255) }
  it { should validate_length_of(:content).is_at_least(10) }
end
