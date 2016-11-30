class AttachmentsController < ApplicationController
  respond_to :json

  authorize_resource

  before_action :find_attachment
  before_action :check_authorship

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def find_attachment
    @attachment = Attachment.find(params[:id])
  end

  def check_authorship
    head :forbidden unless current_user.author_of?(@attachment.attachable)
  end
end
