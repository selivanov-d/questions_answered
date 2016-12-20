class QuestionsDailyDigest < BaseMailer
  def digest(user)
    @questions = Question.select(:id, :title, :content).where('created_at > ?', Time.now - 100.day)

    mail to: user.email, subject: '[QuestionsAnswered]: Вопросы, созданные за последний день'
  end
end
