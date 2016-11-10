module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:upvote, :downvote, :unvote]
    before_action :check_existing_vote, only: [:upvote, :downvote]
  end

  def upvote
    @votable.upvote(current_user)
    response_with_json(:ok)
  end

  def downvote
    @votable.downvote(current_user)
    response_with_json(:ok)
  end

  def unvote
    if @votable.has_vote_from? current_user
      @votable.unvote(current_user)
      response_with_json(:ok)
    else
      render json: { status: 'error', data: 'Вы ещё не дали своего голоса за этот ресурс' }, status: :ok
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_votable
    @votable = model_klass.find(params[:id])
  end

  def check_existing_vote
    response_with_json(:error) if @votable.has_vote_from? current_user
  end

  def response_with_json(result)
    case result
    when :ok
      render json: { status: 'success', rating: @votable.rating }, status: :ok
    when :error
      render json: { status: 'error', data: 'Проголосовать можно только один раз' }, status: :ok
    end
  end
end
