class Api::V1::BaseController < ApplicationController
  respond_to :json

  skip_before_action :authenticate_user!

  before_action :doorkeeper_authorize!
end
