require 'rails_helper'

describe Search do
  it { should validate_presence_of(:query) }
  it { should validate_length_of(:query).is_at_least(3).is_at_most(255) }
  it { should validate_inclusion_of(:subject).in_array(%w(all questions answers comments)) }

  describe '#results' do
    let!(:question) { create(:question, content: 'Questions text containing Bingo word.') }
    let(:query) { 'Bingo' }
    let(:global_search) { Search.new(query: query, subject: 'all') }
    let(:limited_search) { Search.new(query: query, subject: 'questions') }

    it 'performs global search when subject set to \'all\'' do
      expect(ThinkingSphinx).to receive(:search).with(query)
      global_search.results
    end

    it 'performs search limited to questions when subject set to \'questions\'' do
      expect(Question).to receive(:search).with(query)
      limited_search.results
    end

    it 'returns results as array' do
      allow(ThinkingSphinx).to receive(:search).with(query).and_return([question])
      expect(global_search.results.to_json).to eql([SearchResult.new(question)].to_json)
    end
  end
end
