class QuestionsDailyDigest < ActionMailer::Base
  default from: 'admin@questions-answered.com'

  def digest(user)
    @questions = Question.select(:id, :title, :content).where('created_at > ?', Time.now - 1.day)

    mail to: user.email, subject: '[QuestionsAnswered]: Вопросы, созданные за последний день'
  end
end
