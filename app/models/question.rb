class Question < ActiveRecord::Base
  include Votable
  include Commentable
  include Attachable

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :title, presence: true, length: { in: 10..255 }
  validates :content, presence: true, length: { minimum: 10 }

  after_create :broadcast_new_question

  private

  def broadcast_new_question
    ActionCable.server.broadcast 'QuestionsChannel', question: self
  end
end
