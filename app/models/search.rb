class Search
  include ActiveModel::Model
  include SearchesHelpers

  attr_accessor :query, :subject

  validates :query, presence: true, length: { in: 3..255 }
  validates :subject, inclusion: %w(all questions answers comments)

  def results
    @results ||= []

    return @results if self.invalid?

    results = subject_klass.search(query)

    @results = format_results(results) unless results.nil?
  end

  private

  def subject_klass
    return ThinkingSphinx if subject == 'all'

    subject.singularize.capitalize.constantize
  end

  def format_results(results)
    results.map! { |result| question_from_result(result) }
    results.uniq
  end
end
