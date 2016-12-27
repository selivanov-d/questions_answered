class AnswerNotification < BaseMailer
  def new_answer(answer)
    @answer = answer

    mail to: @answer.question.user.email, subject: '[QuestionsAnswered]: На ваш вопрос дан ответ'
  end

  def new_answer_for_subscriber(subscriber, answer)
    @answer = answer

    mail to: subscriber.email, subject: '[QuestionsAnswered]: На интересующий вас вопрос дан ответ'
  end
end
