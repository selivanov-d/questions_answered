class CommentsController < ApplicationController
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
    if params[:question_id]
      @commentable = Question.find(params[:question_id])
    elsif params[:answer_id]
      @commentable = Answer.find(params[:answer_id])
    end
  end
end
