module Votable
  extend ActiveSupport::Concern

  def upvote(user)
    user.votes << Vote.create(votable: self, positive: true)
  end

  def downvote(user)
    user.votes << Vote.create(votable: self, positive: false)
  end

  def unvote(user)
    user.votes.by_votable(self).destroy_all
  end

  def rating
    # TODO: refactor
    (votes.count - votes.negative.count) - votes.negative.count
  end

  def has_votes_from?(user)
    Vote.voted_by_user(user, self).any?
  end
end
