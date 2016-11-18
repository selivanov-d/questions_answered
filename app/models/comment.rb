class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:commentable_type, :commentable_id] }
  validates :content, presence: true, length: { minimum: 10 }
end
