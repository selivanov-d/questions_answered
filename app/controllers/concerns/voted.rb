module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:upvote, :downvote]
  end

  def upvote
    @votable.upvote(current_user)
    render json: { status: 'success', rating: @votable.rating }, status: :ok
  end

  def downvote
    @votable.downvote(current_user)
    render json: { status: 'success', rating: @votable.rating }, status: :ok
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_votable
    @votable = model_klass.find(params[:id])
  end

  def respond(result)
    if result[:success]
      render json: result[:data], status: :ok
    else
      render json: result[:errors], status: :unprocessable_entity
    end
  end
end
