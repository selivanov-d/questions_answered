class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])

    parent_class = @attachment.attachable_type.constantize
    @parent = parent_class.find(@attachment.attachable_id)

    if current_user.author_of?(@parent)
      @attachment.destroy
      render json: { status: 'success', data: { message: 'Приложение удалено' } }, status: :ok
    else
      render json: { status: 'error', data: { message: 'Удалить можно только приложение у своего вопроса или ответа' } }, status: :forbidden
    end
  end
end
