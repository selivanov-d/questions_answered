require 'rails_helper'

feature 'Delete question', %q{
  In order to remove question from website
  As an authenticated user
  I want to be able to delete question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user deletes his own question' do
    sign_in(user)

    page.driver.submit :delete, question_path(question), {}

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Ваш вопрос удалён'
  end

  scenario 'Authenticated user tries to delete not his own question' do
    sign_in(user)

    user2 = create(:user)
    question2 = create(:question, user: user2)

    page.driver.submit :delete, question_path(question2), {}

    expect(current_path).to eq question_path(question2)
    expect(page).to have_content 'Удалить можно только свой вопрос'
  end

  scenario 'Non-authenticated user tries to delete question' do
    page.driver.submit :delete, question_path(question), {}

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
