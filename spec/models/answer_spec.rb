require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :content }
  it { should validate_length_of(:content).is_at_least(10) }
  it { should validate_uniqueness_of(:best).scoped_to(:question_id) }

  describe '#mark_as_best makes an answer the best answer for a question' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:best_answer) { create(:best_answer, question: question, user: user) }

    it 'changes `best` attribute of an answer' do
      answer.mark_as_best
      expect(answer.best?).to eq true
    end

    it 'does not changes `best` attribute of an answer if it already marked as best' do
      best_answer.mark_as_best
      expect(best_answer.best?).to eq true
    end
  end
end
