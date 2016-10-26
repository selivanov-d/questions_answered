class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :content, presence: true, length: { minimum: 10 }
  validates :best, uniqueness: { scope: :question_id }, if: :best

  scope :best_for, ->(question_id) { where(best: true, question_id: question_id) }
  scope :best_first, -> { order(best: :desc) }

  def mark_as_best
    current_best = Answer.best_for(question_id).first

    current_best.update_attributes(best: false) if current_best.present?

    self.best = true
  end
end
