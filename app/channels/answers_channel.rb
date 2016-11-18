class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'AnswersChannel'
  end

  def unsubscribed

  end
end
