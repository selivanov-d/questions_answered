require 'rails_helper'

describe Search do
  it { should validate_presence_of(:query) }
  it { should validate_length_of(:query).is_at_least(3).is_at_most(255) }
  it { should validate_inclusion_of(:subject).in_array(%w(all questions answers comments)) }

  describe '#results' do
    let!(:question) { create(:question, content: 'Question text containing Bingo word.') }
    let!(:answer) { create(:answer, content: 'Answer text containing Bingo word.') }
    let!(:comment) { create(:comment, content: 'Comment text containing Bingo word.') }

    context 'when valid query given' do
      let(:query) { 'Bingo' }
      let(:search) { Search.new(query: query, subject: 'all') }

      context 'when subject set to \'all\'' do
        it 'performs global search' do
          expect(ThinkingSphinx).to receive(:search).with(query)
          search.results
        end

        it 'returns results as array' do
          allow(ThinkingSphinx).to receive(:search).with(query).and_return([question, answer, comment])
          expect(search.results.to_json).to eql([SearchResult.new(question), SearchResult.new(answer), SearchResult.new(comment)].to_json)
        end
      end

      %w(questions answers comments).each do |subject|
        context "when subject set to '#{subject}'" do
          let(:subject_variable_name) { subject.singularize }
          let(:subject_klass) { subject.singularize.capitalize.constantize }

          before do
            search.subject = subject
          end

          it "performs search limited to #{subject}" do
            expect(subject_klass).to receive(:search).with(query)
            search.results
          end

          it 'returns results as array' do
            allow(subject_klass).to receive(:search).with(query).and_return([send(subject_variable_name)])
            expect(search.results.to_json).to eql([SearchResult.new(send(subject_variable_name))].to_json)
          end
        end
      end
    end

    context 'when invalid query given' do
      let(:query) { 'no' }
      let(:search) { Search.new(query: query, subject: 'all') }

      context 'when subject set to \'all\'' do
        it 'does not perform global search' do
          expect(ThinkingSphinx).to_not receive(:search).with(query)
          search.results
        end

        it 'returns empty array' do
          expect(search.results).to be_empty
        end
      end

      %w(questions answers comments).each do |subject|
        context "when subject set to '#{subject}'" do
          let(:subject_klass) { subject.singularize.capitalize.constantize }

          before do
            search.subject = subject
          end

          it "does not performs search limited to #{subject}" do
            expect(subject_klass).to_not receive(:search).with(query)
            search.results
          end

          it 'returns empty array' do
            expect(search.results).to be_empty
          end
        end
      end
    end
  end
end
