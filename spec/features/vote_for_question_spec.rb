require 'rails_helper'

feature 'Voting for a question', %q{
  In order to praise or to criticize a question
  As an authenticated user
  I want to be able to give it my vote
} do

  let(:question) { create(:question) }

  context 'Authenticated user' do
    context 'not his question' do
      let(:user) { create(:user) }

      before :each do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'upvotes a question', js: true do
        within '.js-question-vote-control' do
          click_on('+1')

          expect(page).to_not have_content('+1')
          expect(page).to_not have_content('-1')
          expect(page).to have_content('Переголосовать')
        end

        within '.js-votes-count' do
          expect(page).to have_content('1')
        end
      end

      scenario 'tries to upvote a question twice', js: true do
        within '.js-question-vote-control' do
          click_on('+1')

          expect(page).to_not have_content('+1')
        end
      end

      scenario 'downvotes a question', js: true do
        within '.js-question-vote-control' do
          click_on('-1')

          expect(page).to_not have_content('+1')
          expect(page).to_not have_content('-1')
          expect(page).to have_content('Переголосовать')
        end

        within '.js-votes-count' do
          expect(page).to have_content('-1')
        end
      end

      scenario 'tries to downvote a question twice', js: true do
        within '.js-question-vote-control' do
          click_on('-1')

          expect(page).to_not have_content('-1')
        end
      end

      scenario 'removes his vote from a question', js: true do
        within '.js-question-vote-control' do
          click_on('+1')
          click_on('Переголосовать')

          expect(page).to have_content('-1')
          expect(page).to have_content('+1')
          expect(page).to_not have_content('Переголосовать')
        end

        within '.js-votes-count' do
          expect(page).to have_content('0')
        end
      end
    end

    context 'his own question' do
      before :each do
        sign_in(question.user)
        visit question_path(question)
      end

      scenario 'tries to upvote a question', js: true do
        within '.js-question-vote-control' do
          expect(page).to_not have_content('+1')
        end
      end

      scenario 'tries to downvote a question', js: true do
        within '.js-question-vote-control' do
          expect(page).to_not have_content('-1')
        end
      end

      scenario 'tries to remove his vote from a question', js: true do
        within '.js-question-vote-control' do
          expect(page).to_not have_content('Переголосовать')
        end
      end
    end
  end

  context 'Non-authenticated user' do
    before :each do
      visit question_path(question)
    end

    scenario 'tries to upvote a question', js: true do
      within '.js-question-vote-control' do
        expect(page).to_not have_content('+1')
      end
    end

    scenario 'tries to downvote a question', js: true do
      within '.js-question-vote-control' do
        expect(page).to_not have_content('-1')
      end
    end
  end
end
