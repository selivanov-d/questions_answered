require 'rails_helper'

feature 'Create comment for answer', %q{
  In order to give additional information for an answer
  As an authenticated user
  I want to be able to leave comments
} do

  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  context 'Authenticated user' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment with valid data', js: true do
      within ".js-answer[data-answer-id='#{answer.id}']" do
        find('.js-new-comment-trigger').click

        fill_in 'comment_content', with: 'New comment for answer test content'

        click_on 'Сохранить комментарий'
      end

      expect(current_path).to eq question_path(question)

      within '.js-comments-for-answer-list' do
        expect(page).to have_content('New comment for answer test content')
      end
    end

    scenario 'creates comment with invalid data', js: true do
      within ".js-answer[data-answer-id='#{answer.id}']" do
        find('.js-new-comment-trigger').click

        fill_in 'comment_content', with: 'no_text'

        click_on 'Сохранить комментарий'
      end

      expect(current_path).to eq question_path(question)

      within '.js-comments-for-question-list' do
        expect(page).to_not have_content('no_text')
      end
    end
  end

  context 'Non-authenticated user' do
    scenario 'tries to create comment', js: true do
      visit question_path(question)

      within ".js-answer[data-answer-id='#{answer.id}']" do
        expect(page).to_not have_content('Добавить комментарий')
      end
    end
  end

  context 'All users get new questions in real-time' do
    before :each do
      author = create(:user)
      guest = create(:user)

      Capybara.using_session('authenticated_author_creator') do
        sign_in(author)
        visit question_path(question)
      end

      Capybara.using_session('authenticated_author_reader') do
        sign_in(author)
        visit question_path(question)
      end

      Capybara.using_session('authenticated_guest') do
        sign_in(guest)
        visit question_path(question)
      end

      Capybara.using_session('non_authenticated_guest') do
        visit question_path(question)
      end

      Capybara.using_session('authenticated_author_creator') do
        within ".js-answer[data-answer-id='#{answer.id}']" do
          find('.js-new-comment-trigger').click

          fill_in 'comment_content', with: 'New comment for question test content'

          click_on 'Сохранить комментарий'
        end
      end
    end

    scenario 'authenticated guest', js: true do
      Capybara.using_session('authenticated_guest') do
        within ".js-answer[data-answer-id='#{answer.id}'] .js-comments-for-answer-list" do
          expect(page).to have_content 'New comment for question test content'
        end
      end
    end

    scenario 'non-authenticated guest', js: true do
      Capybara.using_session('non_authenticated_guest') do
        within ".js-answer[data-answer-id='#{answer.id}'] .js-comments-for-answer-list" do
          expect(page).to have_content 'New comment for question test content'
        end
      end
    end

    scenario 'authenticated author as reader', js: true do
      Capybara.using_session('authenticated_author_reader') do
        within ".js-answer[data-answer-id='#{answer.id}'] .js-comments-for-answer-list" do
          expect(page).to have_content 'New comment for question test content'
        end
      end
    end
  end
end
