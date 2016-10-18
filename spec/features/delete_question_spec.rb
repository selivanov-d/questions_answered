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

    visit question_path(question)
    click_on 'Удалить вопрос'

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Ваш вопрос удалён'
  end

  scenario 'Authenticated user tries to delete not his own question' do
    sign_in(user)

    user2 = create(:user)
    question2 = create(:question, user: user2)

    visit question_path(question2)

    expect(current_path).to eq question_path(question2)
    expect(page).to_not have_link('Удалить вопрос')
  end

  scenario 'Non-authenticated user tries to delete question' do
    visit question_path(question)

    expect(current_path).to eq question_path(question)
    expect(page).to_not have_link('Удалить вопрос')
  end
end
