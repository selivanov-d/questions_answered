class CommentsController < ApplicationController
  def create
    @commentable = model_klass.find(params[:id])

    @comment = @commentable.comments.new(comment_params)
    current_user.comments << @comment

    if @comment.save
      render json: { status: 'success', data: { message: 'Ваш коммент сохранён', comment: @comment } }, status: :ok
    else
      render json: { status: 'error', data: @comment.errors }, status: :ok
    end
  end

  private

  # TODO: move somewhere?
  def model_klass
    controller_name.classify.constantize
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
