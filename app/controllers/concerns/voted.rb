module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:upvote, :downvote, :unvote]
    before_action :check_votable_ownership, only: [:upvote, :downvote]
    before_action :check_existing_vote, only: [:upvote, :downvote]
  end

  def upvote
    @votable.upvote(current_user)
    response_with_ok_json
  end

  def downvote
    @votable.downvote(current_user)
    response_with_ok_json
  end

  def unvote
    if @votable.has_vote_from? current_user
      @votable.unvote(current_user)
      response_with_ok_json
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
    if @votable.has_vote_from? current_user
      render json: { status: 'error', data: 'Проголосовать можно только один раз' }, status: :ok
    end
  end

  def check_votable_ownership
    if current_user.author_of? @votable
      render json: { status: 'error', data: 'Вы не можете голосовать за свой ресурс' }, status: :forbidden
    end
  end

  def response_with_ok_json
    render json: { status: 'success', rating: @votable.rating }, status: :ok
  end
end
