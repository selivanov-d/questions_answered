require 'rails_helper'

describe SearchesHelpers, type: :helper do
  helper SearchesHelpers

  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:comment) { create(:comment_for_question) }

  describe '#question_from_result' do
    context 'when question given' do
      it 'returns question' do
        expect(helper.question_from_result(question)).to eq(question)
      end
    end

    context 'when answer given' do
      it 'returns question' do
        expect(helper.question_from_result(answer)).to eq(answer.question)
      end
    end

    context 'when comment given' do
      it 'returns question' do
        expect(helper.question_from_result(comment)).to eq(comment.commentable)
      end
    end
  end

  describe '#question_from_commentable' do
    context 'when question given' do
      it 'returns question' do
        expect(helper.question_from_commentable(question)).to eq(question)
      end
    end

    context 'when answer given' do
      it 'returns question' do
        expect(helper.question_from_commentable(answer)).to eq(answer.question)
      end
    end
  end
end
