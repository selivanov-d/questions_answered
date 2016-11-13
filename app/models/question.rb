class Question < ActiveRecord::Base
  include Votable

  has_many :answers, dependent: :destroy

  validates :title, presence: true, length: { in: 10..255 }
  validates :content, presence: true, length: { minimum: 10 }
end
