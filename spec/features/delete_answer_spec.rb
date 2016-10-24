require 'rails_helper'

feature 'Delete answer', %q{
  In order to remove answer for a question from website
  As an authenticated user
  I want to be able to delete answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  context 'Authenticated user' do
    scenario 'deletes his own answer', js: true do
      sign_in(user)

      answer = create(:answer, user: user, question: question)

      visit question_path(question)

      within ".answer[data-answer-id='#{answer.id}']" do
        click_on 'Удалить ответ'
      end

      expect(current_path).to eq question_path(question)
      expect(page).to have_content('Ваш ответ удалён')
      expect(page).to_not have_content(answer.content)
    end

    scenario 'tries to delete not his own answer', js: true do
      sign_in(user)

      user2 = create(:user)
      create(:answer, user: user2, question: question)

      visit question_path(question)

      expect(current_path).to eq question_path(question)

      expect(page).to_not have_link('Удалить ответ')
    end
  end

  context 'Non-authenticated user' do
    scenario 'tries to delete answer', js: true do
      create(:answer, user: user, question: question)

      visit question_path(question)

      expect(current_path).to eq question_path(question)
      expect(page).to_not have_link('Удалить ответ')
    end
  end
end
