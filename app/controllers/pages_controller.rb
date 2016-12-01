class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check

  def terms
  end

  def policy
  end
end
