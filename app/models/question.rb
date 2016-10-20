class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { in: 10..255 }
  validates :content, presence: true, length: { minimum: 10 }
end
