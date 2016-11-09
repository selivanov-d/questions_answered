class VotesController < ApplicationController
  before_action :authenticate_user!

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
end
