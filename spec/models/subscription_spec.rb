require 'rails_helper'

describe Subscription do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  describe 'validates uniqueness of subscription' do
    subject { create(:subscription) }
    it { should validate_uniqueness_of(:question_id).scoped_to(:user_id) }
  end
end
