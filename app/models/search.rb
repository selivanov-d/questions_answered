class Search
  include ActiveModel::Model

  attr_accessor :query, :subject

  validates :query, presence: true, length: { in: 3..255 }
  validates :subject, inclusion: %w(all questions answers comments)

  def results
    @results ||= []

    return @results if self.invalid?

    results = subject_klass.search(query)

    @results = results.map { |result| SearchResult.new(result) } unless results.nil?

    @results
  end

  private

  def subject_klass
    return ThinkingSphinx if subject == 'all'

    subject.singularize.capitalize.constantize
  end
end
