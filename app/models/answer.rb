class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :content, presence: true, length: { minimum: 10 }
  validates :best, uniqueness: { scope: :question_id }
end
