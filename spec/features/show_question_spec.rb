require 'rails_helper'

def check_question_and_answers
  visit question_path(question)

  expect(page).to have_content(question.title)
  expect(page).to have_content(question.content)

  question.answers.each do |answer|
    expect(page).to have_content(answer.content)
  end
end

feature 'Show question and give answer', %q{
  In order to view question and answers to it
  As an authenticated user
  I want to be able to view question and form for an answer
} do

  let(:user) { create(:user) }
  let(:question) { create(:question_with_answers) }

  scenario 'Authenticated user views question' do
    sign_in(user)

    check_question_and_answers
    expect(page).to have_button('Сохранить ответ')
  end

  scenario 'Non-authenticated user views question' do
    check_question_and_answers
    expect(page).to_not have_button('Сохранить ответ')
  end
end
