class NotificationForQuestionAuthorJob < ApplicationJob
  def perform(answer)
    AnswerNotificationMailer.new_answer(answer).deliver_later
  end
end
