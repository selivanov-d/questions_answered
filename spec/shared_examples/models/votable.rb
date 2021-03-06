require 'rails_helper'

shared_examples_for 'votable' do
  votable_klass_symbol = described_class.to_s.underscore.to_sym

  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let!(:votable) { create(votable_klass_symbol) }

  describe '#upvote creates one positive vote for votable' do
    it 'increases votable rating by one' do
      expect { votable.upvote(user) }.to change(votable, :rating).by(1)
    end
  end

  describe '#downvote creates one negative vote for votable' do
    it 'decreases votable rating by one' do
      expect { votable.downvote(user) }.to change(votable, :rating).by(-1)
    end
  end

  describe '#unvote removes all votes from a certain votable of current user' do
    let(:vote) { create("positive_vote_for_#{votable_klass_symbol}", votable: votable, user: user) }

    it 'drops user votes for a votable to zero' do
      votable.unvote(user)
      expect(Vote.where(user: user, votable: votable).count).to eq(0)
    end
  end

  describe '#rating shows rating of given votable' do
    before do
      create_list("positive_vote_for_#{votable_klass_symbol}", 10, votable: votable)
      create_list("negative_vote_for_#{votable_klass_symbol}", 5, votable: votable)
    end

    it 'show rating equal 5' do
      expect(votable.rating).to eq(5)
    end
  end
end
