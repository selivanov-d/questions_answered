require 'rails_helper'

def view_question_and_count_answers
  visit question_path(question)

  expect(page).to have_content(question.title)
  expect(page).to have_content(question.content)
  expect(page).to have_selector('.js-answer', count: 5)
end

feature 'Show question', %q{
  In order to view question and answers to it
  As an authenticated user
  I want to be able to view question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers) }

  scenario 'Authenticated user views question' do
    sign_in(user)

    view_question_and_count_answers
    expect(page).to have_selector('.js-give-answer', count: 1)
  end

  scenario 'Non-authenticated user views question' do
    visit question_path(question)

    view_question_and_count_answers
    expect(page).to have_selector('.js-give-answer', count: 0)
  end
end
