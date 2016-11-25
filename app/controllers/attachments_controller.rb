class AttachmentsController < ApplicationController
  before_action :find_attachment
  before_action :check_authorship

  respond_to :json

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
