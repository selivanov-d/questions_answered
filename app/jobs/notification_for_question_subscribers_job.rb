class NotificationForQuestionSubscribersJob < ApplicationJob
  def perform(answer)
    answer.question.subscriptions.each do |subscription|
      subscriber = subscription.user
      AnswerNotificationMailer.new_answer_for_subscriber(subscriber, answer).deliver_later
    end
  end
end
