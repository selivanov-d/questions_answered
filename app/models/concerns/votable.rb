module Votable
  extend ActiveSupport::Concern

  def upvote(user)
    user.votes << Vote.create(votable: self, positive: true)
  end

  def downvote(user)
    user.votes << Vote.create(votable: self, positive: false)
  end

  def rating
    # TODO: refactor
    (votes.count - votes.negative.count) - votes.negative.count
  end
end
