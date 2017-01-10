class QuestionsDailyDigestMailer < BaseMailer
  def digest(user, questions)
    @questions = questions
    mail to: user.email, subject: '[QuestionsAnswered]: Вопросы, созданные за последний день'
  end
end
