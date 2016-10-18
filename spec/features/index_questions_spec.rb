require 'rails_helper'

feature 'Index questions', %q{
  In order to select a question to give an answer
  As an authenticated user
  I want to be able to view list of questions
} do

  given(:user) { create(:user) }
  given(:questions) { create_list(:question, 5) }

  scenario 'Authenticated user views list of questions' do
    sign_in(user)

    visit questions_path(questions: questions)

    expect(page).to have_selector('.js-question', count: 5)
    expect(page).to have_selector('a.js-give-answer', count: 5)
  end

  scenario 'Non-authenticated user views list of questions' do
    visit questions_path(questions: questions)

    expect(page).to have_selector('.js-question', count: 5)
    expect(page).to have_selector('a.js-give-answer', count: 0)
  end
end
