require 'rails_helper'

feature 'Voting for a answer', %q{
  In order to praise or to criticize an answer
  As an authenticated user
  I want to be able to give it my vote
} do

  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  context 'Authenticated user' do
    context 'not his answer' do
      let(:user) { create(:user) }

      before :each do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'upvotes an answer', js: true do
        within '.js-answer-vote-control' do
          click_on('+1')

          expect(page).to_not have_content('+1')
          expect(page).to_not have_content('-1')
          expect(page).to have_content('Unvote')
        end

        within '.js-answer-vote-count' do
          expect(page).to have_content('1')
        end
      end

      scenario 'downvotes an answer', js: true do
        within '.js-answer-vote-control' do
          click_on('-1')

          expect(page).to_not have_content('+1')
          expect(page).to_not have_content('-1')
          expect(page).to have_content('Unvote')
        end

        within '.js-answer-vote-count' do
          expect(page).to have_content('-1')
        end
      end

      scenario 'removes his vote from an answer', js: true do
        within '.js-answer-vote-control' do
          click_on('+1')
          click_on('Unvote')

          expect(page).to have_content('-1')
          expect(page).to have_content('+1')
          expect(page).to_not have_content('Unvote')
        end

        within '.js-answer-vote-count' do
          expect(page).to have_content('0')
        end
      end
    end

    context 'his own answer' do
      before :each do
        sign_in(answer.user)
        visit question_path(question)
      end

      scenario 'tries to upvote an answer', js: true do
        within '.js-answer-voting' do
          expect(page).to_not have_content('+1')
        end
      end

      scenario 'tries to downvote an answer', js: true do
        within '.js-answer-voting' do
          expect(page).to_not have_content('-1')
        end
      end

      scenario 'tries to remove his vote from an answer', js: true do
        within '.js-answer-voting' do
          expect(page).to_not have_content('Unvote')
        end
      end
    end
  end

  context 'Non-authenticated user' do
    before :each do
      visit question_path(question)
    end

    scenario 'tries to upvote an answer', js: true do
      within '.js-answer-voting' do
        expect(page).to_not have_content('+1')
      end
    end

    scenario 'tries to downvote an answer', js: true do
      within '.js-answer-voting' do
        expect(page).to_not have_content('-1')
      end
    end
  end
end
