class SearchResult
  attr_accessor :raw_result

  def initialize(result)
    @raw_result = result
  end

  def question
    search_result_original_klass = raw_result.class.to_s

    question_from_raw_result(search_result_original_klass)
  end

  private

  def question_from_raw_result(search_result_original_klass)
    case search_result_original_klass
    when 'Question'
      raw_result
    when 'Answer'
      raw_result.question
    when 'Comment'
      commentable_original_klass = raw_result.commentable.class.to_s

      question_from_commentable(commentable_original_klass)
    end
  end

  def question_from_commentable(commentable_original_klass)
    case commentable_original_klass
    when 'Question'
      raw_result.commentable
    when 'Answer'
      raw_result.commentable.question
    end
  end
end
