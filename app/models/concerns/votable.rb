module Votable
  extend ActiveSupport::Concern

  included do
    has_many :attachments, as: :attachable, dependent: :destroy
    has_many :votes, as: :votable, dependent: :destroy
    belongs_to :user
    accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  end

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
