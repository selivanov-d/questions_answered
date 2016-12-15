require 'rails_helper'
require 'shared_examples/features/comment_ability'

feature 'Create comment for question', %q{
  In order to get additional information
  As an authenticated user
  I want to be able to ask clarifying questions in comments
} do

  it_behaves_like 'comment ability' do
    let(:commentable) { create(:question) }
    let(:commentable_page) { question_path(commentable) }
  end
end
