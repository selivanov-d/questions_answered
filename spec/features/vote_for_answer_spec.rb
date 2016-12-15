require 'rails_helper'
require 'shared_examples/features/vote_ability'

feature 'Voting for a answer', %q{
  In order to praise or to criticize an answer
  As an authenticated user
  I want to be able to give it my vote
} do

  it_behaves_like 'vote ability' do
    let!(:question) { create(:question) }
    let!(:votable) { create(:answer, question: question) }
    let(:votable_page) { question_path(votable) }
  end
end
