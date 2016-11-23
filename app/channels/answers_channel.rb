class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "AnswersForQuestion#{params[:question_id]}Channel"
  end

  def unsubscribed

  end
end
