class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  def create
    @comment = @commentable.comments.new(comment_params)
    current_user.comments << @comment

    if @comment.save
      render json: { status: 'success', data: { message: 'Ваш коммент сохранён', comment: @comment } }, status: :ok
    else
      render json: { status: 'error', data: @comment.errors }, status: :ok
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def load_commentable
    comment_subject = params[:comment][:subject]
    commentable_klass = comment_subject.classify.constantize
    commentable_id_key = "#{comment_subject}_id"

    @commentable = commentable_klass.find(params[commentable_id_key])
  end
end
