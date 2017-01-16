class SearchResultDecorator < Draper::Decorator
  delegate_all

  def question
    case model.raw_result.class.to_s
    when 'Question'
      model.raw_result
    when 'Answer'
      model.raw_result.question
    when 'Comment'
      case model.raw_result.commentable.class.to_s
      when 'Question'
        model.raw_result.commentable
      when 'Answer'
        model.raw_result.commentable.question
      end
    end
  end
end
