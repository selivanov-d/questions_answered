class CommentsController < ApplicationController
  before_action :load_commentable

  respond_to :json

  def create
    @comment = @commentable.comments.new(comment_params)
    current_user.comments << @comment
    respond_with(@comment)
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
