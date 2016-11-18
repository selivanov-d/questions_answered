require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :commentable }
  it { should belong_to(:user) }

  it { should validate_presence_of :content }
  it { should validate_length_of(:content).is_at_least(10) }

  it 'validates uniqueness of' do
    FactoryGirl.create(:comment)
    should validate_uniqueness_of(:user_id).scoped_to([:commentable_type, :commentable_id])
  end
end
