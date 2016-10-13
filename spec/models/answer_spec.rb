require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of :content }
  it { should validate_length_of(:content).is_at_least(10) }
end
