require 'rails_helper'

def check_all_questions_present
  visit questions_path(questions: questions)

  questions.each do |question|
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.content)
  end
end

feature 'Index questions', %q{
  In order to select a question to give an answer
  As an authenticated user
  I want to be able to view list of questions
} do

  given(:user) { create(:user) }
  given(:questions) { create_list(:question, 5) }

  scenario 'Authenticated user views list of questions' do
    sign_in(user)

    check_all_questions_present

    expect(page).to have_link('Дать ответ', count: 5)
  end

  scenario 'Non-authenticated user views list of questions' do
    check_all_questions_present

    expect(page).to_not have_link('Дать ответ')
  end
end
