class QuestionsDigestJob < ApplicationJob
  def perform
    User.send_questions_digest
  end
end
