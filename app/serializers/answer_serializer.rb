class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :content, :question_id, :user_id, :best, :created_at, :updated_at

  def question_id
    object.question_id
  end
end
