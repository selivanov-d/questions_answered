module SearchesHelpers
  def question_from_result(result)
    result_original_klass = result.class.to_s

    case result_original_klass
    when 'Question'
      result
    when 'Answer'
      result.question
    when 'Comment'
      question_from_commentable(result.commentable)
    end
  end

  def question_from_commentable(commentable)
    commentable_original_klass = commentable.class.to_s

    case commentable_original_klass
    when 'Question'
      commentable
    when 'Answer'
      commentable.question
    end
  end
end
