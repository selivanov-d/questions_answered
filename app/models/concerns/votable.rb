module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def upvote(user)
    votes.create(user: user, value: 1)
  end

  def downvote(user)
    votes.create(user: user, value: -1)
  end

  def unvote(user)
    votes.where(user: user).destroy_all
  end

  def rating
    votes.sum(:value)
  end

  def has_vote_from?(user)
    Vote.where(user: user, votable: self).exists?
  end
end
