module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:upvote, :downvote, :unvote]
  end

  def upvote
    if @votable.has_votes_from? current_user
      render json: { status: 'error', data: 'Проголосовать можно только один раз' }, status: :ok
    else
      @votable.upvote(current_user)
      render json: { status: 'success', rating: @votable.rating }, status: :ok
    end
  end

  def downvote
    if @votable.has_votes_from? current_user
      render json: { status: 'error', data: 'Проголосовать можно только один раз' }, status: :ok
    else
      @votable.downvote(current_user)
      render json: { status: 'success', rating: @votable.rating }, status: :ok
    end
  end

  def unvote
    if @votable.has_votes_from? current_user
      @votable.unvote(current_user)
      render json: { status: 'success', rating: @votable.rating }, status: :ok
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

  def load_vote
    current_user.votes.find_by_votable(@votable)
  end

  def respond(result)
    if result[:success]
      render json: result[:data], status: :ok
    else
      render json: result[:errors], status: :unprocessable_entity
    end
  end
end
