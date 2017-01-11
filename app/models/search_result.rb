class SearchResult
  include ActiveModel::Model

  attr_accessor :raw_result

  def initialize(result)
    @raw_result = result
  end
end
