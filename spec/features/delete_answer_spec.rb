require 'rails_helper'

feature 'Delete answer', %q{
  In order to remove answer for a question from website
  As an authenticated user
  I want to be able to delete answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question) }

  scenario 'Authenticated user deletes his own answer' do
    sign_in(user)

    page.driver.submit :delete, answer_path(answer), {}

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Ваш ответ удалён'
  end

  scenario 'Authenticated user tries to delete not his own answer' do
    sign_in(user)

    user2 = create(:user)
    answer2 = create(:answer, user: user2, question: question)

    page.driver.submit :delete, answer_path(answer2), {}

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Удалить можно только свой ответ'
  end

  scenario 'Non-authenticated user tries to delete answer' do
    page.driver.submit :delete, answer_path(answer), {}

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
