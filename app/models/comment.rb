class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :content, presence: true, length: { minimum: 10 }

  after_create :broadcast

  private

  def broadcast
    new_comment_json = ApplicationController.render(partial: 'comments/comment', formats: :json, locals: { comment: self })

    if commentable_type == 'Question'
      ActionCable.server.broadcast "CommentsForQuestion#{commentable_id}", comment: new_comment_json
    elsif commentable_type == 'Answer'
      ActionCable.server.broadcast "CommentsForAnswersForQuestion#{commentable.question_id}", comment: new_comment_json
    end
  end
end
