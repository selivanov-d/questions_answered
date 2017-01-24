class SearchesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check

  def show
    @search = Search.new
  end

  def create
    @search = Search.new(search_params)

    if @search.valid?
      render :create
    else
      render :show
    end
  end

  private

  def search_params
    params.require(:search).permit(:query, :subject)
  end
end
