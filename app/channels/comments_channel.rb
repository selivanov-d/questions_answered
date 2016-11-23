class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "CommentsForQuestion#{params[:question_id]}"
    stream_from "CommentsForAnswersForQuestion#{params[:question_id]}"
  end

  def unsubscribed

  end
end
