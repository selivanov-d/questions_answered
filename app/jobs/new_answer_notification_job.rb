class NewAnswerNotificationJob < ApplicationJob
  def perform(answer)
    answer.question.subscriptions.each do |subscription|
      subscriber = subscription.user
      NewAnswerNotificationMailer.notify(subscriber, answer).deliver_later
    end

    NewAnswerNotificationMailer.notify(answer.question.user, answer).deliver_later
  end
end
