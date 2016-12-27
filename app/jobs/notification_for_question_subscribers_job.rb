class NotificationForQuestionSubscribersJob < ApplicationJob
  queue_as :default

  def perform(subscription, answer)
    subscriber = subscription.user
    AnswerNotification.new_answer_for_subscriber(subscriber, answer).deliver_later
  end
end
