class SearchesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check

  before_action :load_search, only: [:create]
  before_action :create_search, only: [:show]

  def show
  end

  def create
    if @search.valid?
      render :create
    else
      render :show
    end
  end

  private

  def search_params
    params.require(:search).permit(:q, :subject)
  end

  def load_search
    @search = Search.new(search_params)
  end

  def create_search
    @search = Search.new
  end
end
