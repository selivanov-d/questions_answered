class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'QuestionsChannel'
  end

  def unsubscribed

  end
end
