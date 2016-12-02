class Api::V1::ProfilesController < ApplicationController
  respond_to :json

  skip_before_action :authenticate_user!

  before_action :doorkeeper_authorize!

  authorize_resource class: User

  def me
    respond_with current_resource_owner
  end

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end
end