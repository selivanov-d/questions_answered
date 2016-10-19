require 'rails_helper'

feature 'Create question', %q{
  In order to get answer for my question from community
  As an authenticated user
  I want to be able ask question
} do

  given(:user) { create(:user) }

  context 'Authenticated user' do
    background do
      sign_in(user)

      visit new_question_path
    end

    scenario 'creates question with valid data' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Content', with: 'Test question content'
      click_on 'Создать'

      expect(current_path).to eq question_path(Question.last)
      expect(page).to have_content('Ваш вопрос успешно создан')
      expect(page).to have_content('Test question')
      expect(page).to have_content('Test question content')
    end

    scenario 'creates question with invalid data' do
      fill_in 'Title', with: ''
      fill_in 'Content', with: ''
      click_on 'Создать'

      expect(current_path).to eq questions_path
      expect(page).to have_content('[:title] can\'t be blank')
      expect(page).to have_content('[:title] is too short (minimum is 10 characters)')
      expect(page).to have_content('[:content] can\'t be blank')
      expect(page).to have_content('[:content] is too short (minimum is 10 characters)')
    end

    scenario 'creates question with invalid data (title too long)' do
      fill_in 'Title', with: 'a' * 256
      fill_in 'Content', with: ''
      click_on 'Создать'

      expect(current_path).to eq questions_path
      expect(page).to have_content('[:title] is too long (maximum is 255 characters)')
      expect(page).to have_content('[:content] can\'t be blank')
      expect(page).to have_content('[:content] is too short (minimum is 10 characters)')
    end
  end

  context 'Non-authenticated user' do
    scenario 'tries to create question' do
      visit new_question_path

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
