class Answer < ActiveRecord::Base
  include Votable
  include Commentable
  include Attachable

  belongs_to :question
  belongs_to :user

  validates :content, presence: true, length: { minimum: 10 }
  validates :best, uniqueness: { scope: :question_id }, if: :best

  scope :best_for, ->(question_id) { where(best: true, question_id: question_id) }
  scope :best_first, -> { order(best: :desc) }

  after_create :broadcast_new_answer
  after_create :notify_question_author
  after_create :notify_subscribers

  def mark_as_best
    Answer.transaction do
      current_best = Answer.best_for(question_id).first

      current_best.update_attributes!(best: false) if current_best.present?

      update_attributes!(best: true)
    end
  end

  private

  def broadcast_new_answer
    new_answer_json = ApplicationController.render('answers/create', formats: :json, locals: { answer: self })
    ActionCable.server.broadcast "AnswersForQuestion#{question_id}Channel", answer: new_answer_json
  end

  def notify_question_author
    NotificationForQuestionAuthorJob.perform_later(self)
  end

  def notify_subscribers
    question.subscriptions.each do |subscription|
      NotificationForQuestionSubscribersJob.perform_later(subscription, self)
    end
  end
end
