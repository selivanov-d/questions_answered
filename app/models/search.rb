class Search
  include ActiveModel::Model

  attr_accessor :q, :subject

  validates :q, presence: true, length: { in: 3..255 }
  validates :subject, inclusion: %w(all questions answers comments)

  def results
    results = subject_klass.search(q, excerpts: {
      :before_match    => '<span class="match">',
      :after_match     => '</span>'
    })

    results.context[:panes] << ThinkingSphinx::Panes::ExcerptsPane

    @results = []
    results.each do |result|
      @results << SearchResultDecorator.decorate(SearchResult.new(result))
    end

    @results
  end

  private

  def subject_klass
    return ThinkingSphinx if subject == 'all'

    subject.singularize.capitalize.constantize
  end
end
