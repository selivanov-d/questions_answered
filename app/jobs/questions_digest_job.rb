class QuestionsDigestJob < ApplicationJob
  queue_as :default

  def perform
    User.send_questions_digest
  end
end
