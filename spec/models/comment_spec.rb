require 'rails_helper'
require 'shared_examples/models/broadcastable'

describe Comment, type: :model do
  it_should_behave_like 'broadcastable'

  it { should belong_to(:commentable) }
  it { should belong_to(:user) }

  it { should validate_presence_of :content }
  it { should validate_length_of(:content).is_at_least(10) }
end
