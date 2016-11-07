require 'rails_helper'

RSpec.describe Answer do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:attachments).dependent(:destroy) }

  it { should validate_presence_of :content }
  it { should validate_length_of(:content).is_at_least(10) }
  it { should validate_uniqueness_of(:best).scoped_to(:question_id) }

  it { should accept_nested_attributes_for :attachments }

  describe '#mark_as_best makes an answer the best answer for a question' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'best answer does not exists' do
      it 'changes `best` attribute of an answer' do
        answer.mark_as_best
        expect(answer.best?).to eq true
      end
    end

    context 'best answer already exists' do
      let!(:best_answer) { create(:best_answer, question: question, user: user) }

      it 'changes `best` attribute of both answers' do
        answer.mark_as_best
        best_answer.reload
        expect(answer.best?).to eq true
        expect(best_answer.best?).to eq false
      end

      it 'does not changes `best` attribute of an answer if it already marked as best' do
        best_answer.mark_as_best
        expect(best_answer.best?).to eq true
      end
    end
  end
end
