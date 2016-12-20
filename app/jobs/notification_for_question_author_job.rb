class NotificationForQuestionAuthorJob < ApplicationJob
  queue_as :default

  def perform(answer)
    AnswerNotification.new_answer(answer).deliver_later
  end
end
