class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :title, presence: true
  validates :title, length: { in: 10..255 }
  validates :content, presence: true
  validates :content, length: { minimum: 10 }
end
