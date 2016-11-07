require 'rails_helper'

RSpec.describe User do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:votes) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of? checks authorship' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'returns true if given object belongs to user' do
      expect(user.author_of?(question)).to eq true
    end

    it 'returns false if given object does not belongs to user' do
      expect(user2.author_of?(question)).to eq false
    end
  end
end
