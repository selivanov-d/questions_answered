class SingleQuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :user_id, :created_at, :updated_at
  has_many :answers
  has_many :comments
  has_many :attachments

  def attachments
    object.attachments.map { |attachment| attachment.file.url }
  end
end
