class AnswerNotification < BaseMailer
  def new_answer(answer)
    @answer = answer

    mail to: @answer.question.user.email, subject: '[QuestionsAnswered]: На ваш вопрос дан ответ'
  end
end
