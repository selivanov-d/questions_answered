class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def terms
  end

  def policy
  end
end
