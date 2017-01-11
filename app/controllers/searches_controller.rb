class SearchesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check

  before_action :load_search, only: [:create]

  def show

  end

  def create
    if @search.valid?
      @search_results = @search.results
    else
      abort
    end
  end

  private

  def search_params
    params.require(:search).permit(:q, :subject)
  end

  def load_search
    @search = Search.new(search_params)
  end
end
