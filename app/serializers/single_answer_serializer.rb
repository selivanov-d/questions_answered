class SingleAnswerSerializer < ActiveModel::Serializer
  attributes :id, :content, :question_id, :user_id, :best, :created_at, :updated_at
  has_many :comments
  has_many :attachments

  def question_id
    object.question_id
  end

  def attachments
    object.attachments.map { |attachment| "#{instance_options[:host]}#{attachment.file.url}" }
  end
end
