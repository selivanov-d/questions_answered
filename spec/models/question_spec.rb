require 'rails_helper'
require 'shared_examples/models/votable_spec'
require 'shared_examples/models/commentable_spec'
require 'shared_examples/models/broadcastable_spec'
require 'shared_examples/models/attachable_spec'

RSpec.describe Question do
  it_should_behave_like 'votable'
  it_should_behave_like 'commentable'
  it_should_behave_like 'broadcastable'
  it_should_behave_like 'attachable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :content }
  it { should validate_length_of(:title).is_at_least(10).is_at_most(255) }
  it { should validate_length_of(:content).is_at_least(10) }
end
