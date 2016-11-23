class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :content, presence: true, length: { minimum: 10 }

  after_create :broadcast_new_comment

  private

  def broadcast_new_comment
    new_comment_json = ApplicationController.render(partial: 'comments/comment', formats: :json, locals: { comment: self })

    subscription_name = case commentable_type
      when 'Question'
        "CommentsForQuestion#{commentable_id}"
      when 'Answer'
        "CommentsForAnswersForQuestion#{commentable.question_id}"
    end

    ActionCable.server.broadcast subscription_name, comment: new_comment_json
  end
end
