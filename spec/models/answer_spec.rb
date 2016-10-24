require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :content }
  it { should validate_length_of(:content).is_at_least(10) }
  it { should validate_uniqueness_of(:best).scoped_to(:question_id) }
end
