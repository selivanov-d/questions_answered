require 'rails_helper'

feature 'Create answer', %q{
  In order to give an answer to a certain question from community
  As an authenticated user
  I want to be able to give new answer
} do

  given(:question) { create(:question) }

  context 'Authenticated user' do
    given(:user) { create(:user) }

    scenario 'creates answer with valid data', js: true do
      sign_in(user)

      visit question_path(question)

      fill_in 'Content', with: 'Test question content'
      click_on 'Дать ответ'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        expect(page).to have_content('Test question content')
      end
    end

    scenario 'creates answer with invalid data', js: true do
      sign_in(user)

      visit question_path(question)

      fill_in 'Content', with: 'no_text'
      click_on 'Дать ответ'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        expect(page).to_not have_content('no_text')
      end
    end
  end

  context 'Non-authenticated user' do
    scenario 'tries to create answer', js: true do
      visit question_path(question)

      expect(page).to_not have_button('Дать ответ')
    end
  end
end
