require 'rails_helper'

feature 'Index questions', %q{
  In order to give an answer to a certain question
  As an authenticated user
  I want to be able to view question and create new answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates answer' do
    sign_in(user)

    visit question_path(question)
    click_on 'Дать ответ'
    expect(current_path).to eq new_question_answer_path(question)

    fill_in 'Content', with: 'Test question content'
    click_on 'Сохранить'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content('Test question content')
  end

  scenario 'Non-authenticated user tries to give answer' do
    visit question_path(question)

    expect(page).to have_selector('a.js-save-answer', count: 0)
  end
end
