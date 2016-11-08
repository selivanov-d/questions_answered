class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_resource, only: [:create]

  def create
    @vote = current_user.votes.new(vote_params)
    @vote.votable = @resource

    if @vote.save
      render json: { status: 'success', rating: @resource.rating }, status: :ok
    else
      render json: { status: 'error', data: @vote.errors }, status: :ok
    end
  end

  def destroy
  end

  private

  def vote_params
    params.require(:vote).permit(:positive, :votable)
  end

  def load_resource
    @resource = if params[:question_id].present?
                  Question.find(params[:question_id])
                elsif params[:answer_id].present?
                  Answer.find(params[:question_id])
                end
  end
end
