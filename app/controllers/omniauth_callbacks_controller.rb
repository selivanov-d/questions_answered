class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :get_auth_hash
  before_action :find_user
  before_action :process_authorization

  def facebook
  end

  def twitter
  end

  private

  def get_auth_hash
    @auth = request.env['omniauth.auth']
  end

  def find_user
    @user = User.find_for_oauth(@auth)
  end

  def process_authorization
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: @auth.provider.capitalize) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Authentication failed, please try again.'
    end
  end
end
