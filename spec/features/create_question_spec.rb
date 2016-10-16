require 'rails_helper'

feature 'Create question', %q{
  In order to get answer question from community
  As an authenticated user
  I want to be able ask question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Задать вопрос'
    fill_in 'Title', with: 'Test question'
    fill_in 'Content', with: 'Test question content'
    click_on 'Создать'

    expect(page).to have_content 'Ваш вопрос успешно создан'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Задать вопрос'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
