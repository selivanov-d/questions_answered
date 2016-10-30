class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    attachment = Attachment.find(params[:id])

    attachment.destroy

    render json: { status: 'success', data: { message: 'Приложение удалено' } }, status: :ok
  end
end
