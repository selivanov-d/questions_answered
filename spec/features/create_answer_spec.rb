require 'rails_helper'

feature 'Create answer', %q{
  In order to give an answer to a certain question from community
  As an authenticated user
  I want to be able to give new answer
} do

  let(:question) { create(:question) }

  context 'Authenticated user' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates answer with valid data', js: true do
      within '.js-new-answer-for-question-form' do
        fill_in 'Content', with: 'Test question content'

        click_on 'Добавить файл'
        click_on 'Добавить файл'

        file_input = all('input[type="file"]')
        file_input[0].set(Rails.root + 'spec/support/files/test-file.jpg')
        file_input[1].set(Rails.root + 'spec/support/files/image.jpg')

        click_on 'Сохранить ответ'
      end

      expect(current_path).to eq question_path(question)

      within '.js-answers-index-table' do
        expect(page).to have_content('Test question content')
        expect(page).to have_content('test-file.jpg')
        expect(page).to have_content('image.jpg')
      end
    end

    scenario 'creates answer with invalid data', js: true do
      within '.js-new-answer-for-question-form' do
        fill_in 'Content', with: 'no_text'

        click_on 'Добавить файл'
        file_input = all('input[type="file"]')
        file_input[0].set(Rails.root + 'spec/support/files/test-file.jpg')

        click_on 'Сохранить ответ'
      end

      expect(current_path).to eq question_path(question)

      within '.answers-index' do
        expect(page).to_not have_content('no_text')
        expect(page).to_not have_content('test-file.jpg')
      end
    end
  end

  context 'Non-authenticated user' do
    scenario 'tries to create answer', js: true do
      visit question_path(question)

      expect(page).to_not have_button('Сохранить ответ')
    end
  end

  context 'All users get new questions in real-time' do
    before :each do
      author = create(:user)
      guest = create(:user)
      question = create(:question, user: author)

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
        fill_in 'Content', with: 'New answer test content'
        click_on 'Сохранить ответ'
      end
    end

    scenario 'authenticated guest', js: true do
      Capybara.using_session('authenticated_guest') do
        expect(page).to have_content 'New answer test content'
      end
    end

    scenario 'non-authenticated guest', js: true do
      Capybara.using_session('non_authenticated_guest') do
        expect(page).to have_content 'New answer test content'
      end
    end

    scenario 'authenticated author as reader', js: true do
      Capybara.using_session('authenticated_author_reader') do
        expect(page).to have_content 'New answer test content'
      end
    end
  end
end
