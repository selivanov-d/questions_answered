require 'rails_helper'

feature 'Create answer', %q{
  In order to give an answer to a certain question from community
  As an authenticated user
  I want to be able to give new answer
} do

  given(:question) { create(:question) }

  context 'Authenticated user' do
    given(:user) { create(:user) }

    scenario 'creates answer with valid data' do
      sign_in(user)

      visit question_path(question)

      fill_in 'Content', with: 'Test question content'
      click_on 'Дать ответ'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content('Ваш ответ сохранён')
      expect(page).to have_content('Test question content')
    end

    scenario 'creates answer with invalid data' do
      sign_in(user)

      visit question_path(question)

      fill_in 'Content', with: ''
      click_on 'Дать ответ'

      expect(current_path).to eq question_answers_path(question)
      expect(page).to have_content('can\'t be blank')
      expect(page).to have_content('is too short (minimum is 10 characters)')
    end
  end

  context 'Non-authenticated user' do
    scenario 'tries to create answer' do
      visit question_path(question)

      expect(page).to_not have_button('Дать ответ')
    end
  end
end
