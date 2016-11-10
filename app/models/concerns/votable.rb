module Votable
  extend ActiveSupport::Concern

  def upvote(user)
    user.votes.create(votable: self, value: 1)
  end

  def downvote(user)
    user.votes.create(votable: self, value: -1)
  end

  def unvote(user)
    user.votes.by_votable(self).destroy_all
  end

  def rating
    Vote.where(votable: self).sum(:value)
  end

  def has_vote_from?(user)
    Vote.by_user(user).by_votable(self).any?
  end
end
