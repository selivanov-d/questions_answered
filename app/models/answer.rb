class Answer < ActiveRecord::Base
  belongs_to :question

  validates :content, presence: true
  validates :content, length: { minimum: 10 }
end
