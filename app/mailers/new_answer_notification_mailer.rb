class NewAnswerNotificationMailer < BaseMailer
  def notify(receiver, answer)
    @answer = answer

    if receiver.author_of?(answer)
      @title = 'Новый ответ на ваш вопрос'
    else
      @title = 'На интересующий вас вопрос дан ответ'
    end

    mail to: receiver.email, subject: "[QuestionsAnswered]: #{@title}"
  end
end
