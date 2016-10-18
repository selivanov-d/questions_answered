require 'rails_helper'

feature 'Create question', %q{
  In order to get answer for my question from community
  As an authenticated user
  I want to be able ask question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Content', with: 'Test question content'
    click_on 'Создать'

    expect(page).to have_content 'Ваш вопрос успешно создан'
    expect(page).to have_content('Test question content')
  end

  scenario 'Non-authenticated user tries to create question' do
    visit new_question_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
