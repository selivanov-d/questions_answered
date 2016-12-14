require 'rails_helper'

describe Vote, type: :model do
  it { should belong_to(:votable) }
  it { should belong_to(:user) }

  describe 'validates uniqueness of vote' do
    subject { create(:positive_vote_for_answer) }

    it { should validate_uniqueness_of(:user_id).scoped_to([:votable_type, :votable_id]) }
  end
end
