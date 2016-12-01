require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :authenticate_user!

  before_action { gon.push({ current_user_id: current_user.try(:id) }) }

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.js { head :forbidden }
      format.html { redirect_to root_path, alert: exception.message }
    end
  end
end
