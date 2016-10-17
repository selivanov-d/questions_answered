require 'rails_helper'

feature 'Delete question', %q{
  In order to delete question
  As an authenticated user
  I want to be able to delete question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user deletes question' do
    sign_in(user)

    page.driver.submit :delete, question_path(question), {}

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Ваш вопрос удалён'
  end

  scenario 'Non-authenticated user tries to delete question' do
    page.driver.submit :delete, question_path(question), {}

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
