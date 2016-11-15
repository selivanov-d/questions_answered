class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:votable_type, :votable_id] }

  scope :by_user, ->(user) { where(user: user) }
  scope :by_votable, ->(votable) { where(votable: votable) }
end
