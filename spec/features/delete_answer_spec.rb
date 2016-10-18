require 'rails_helper'

feature 'Delete answer', %q{
  In order to remove answer for a question from website
  As an authenticated user
  I want to be able to delete answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user deletes his own answer' do
    sign_in(user)

    create(:answer, user: user, question: question)

    visit question_path(question)
    click_on 'Удалить ответ'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content('Ваш ответ удалён')
  end

  scenario 'Authenticated user tries to delete not his own answer' do
    sign_in(user)

    user2 = create(:user)
    create(:answer, user: user2, question: question)

    visit question_path(question)

    expect(current_path).to eq question_path(question)
    expect(page).to_not have_link('Удалить ответ')
  end

  scenario 'Non-authenticated user tries to delete answer' do
    create(:answer, user: user, question: question)

    visit question_path(question)

    expect(current_path).to eq question_path(question)
    expect(page).to_not have_link('Удалить ответ')
  end
end
