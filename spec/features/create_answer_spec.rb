require 'rails_helper'

feature 'Create answer', %q{
  In order to give an answer to a certain question from community
  As an authenticated user
  I want to be able to give new answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates answer' do
    sign_in(user)

    visit question_path(question)

    fill_in 'Content', with: 'Test question content'
    click_on 'Дать ответ'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content('Ваш ответ сохранён')
    expect(page).to have_content('Test question content')
  end

  scenario 'Non-authenticated user tries to give answer' do
    visit question_path(question)

    expect(page).to_not have_button('Дать ответ')
  end
end
