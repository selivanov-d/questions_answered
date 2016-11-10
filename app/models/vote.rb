class Vote < ApplicationRecord
  belongs_to :votable, optional: true, polymorphic: true
  belongs_to :user

  scope :by_user, ->(user) { where(user: user) }
  scope :by_votable, ->(votable) { where(votable: votable) }
end
