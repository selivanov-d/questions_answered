class NotificationForQuestionAuthorJob < ApplicationJob
  queue_as :default

  def perform(answer)
    AnswerNotificationMailer.new_answer(answer).deliver_later
  end
end
