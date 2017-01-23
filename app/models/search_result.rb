class SearchResult
  include ActiveModel::Model

  attr_accessor :raw_result

  def initialize(result)
    @raw_result = result
  end

  def question
    search_result_original_klass = raw_result.class.to_s

    case search_result_original_klass
    when 'Question'
      raw_result
    when 'Answer'
      raw_result.question
    when 'Comment'
      commentable_original_klass = raw_result.commentable.class.to_s

      case commentable_original_klass
      when 'Question'
        raw_result.commentable
      when 'Answer'
        raw_result.commentable.question
      end
    end
  end
end
