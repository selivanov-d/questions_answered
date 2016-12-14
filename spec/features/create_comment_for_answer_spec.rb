require 'rails_helper'
require 'shared_examples/features/comment_ability'

feature 'Create comment for answer', %q{
  In order to give additional information for an answer
  As an authenticated user
  I want to be able to leave comments
} do

  it_behaves_like 'comment ability' do
    let(:question) { create(:question) }
    let!(:commentable) { create(:answer, question: question) }
    let(:commentable_page) { question_path(question) }
  end
end
