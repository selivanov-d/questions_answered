require 'rails_helper'

feature 'Mark answer as best', %q{
  In order to pick answer that resolved my problem and to praise user who gave it
  As an authenticated user
  I want to be able to mark answer as the best
} do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  context 'Authenticated user marks answer as the best' do
    before do
      sign_in(user)

      @answer = create(:answer, question: question, user: user)
    end

    scenario 'there is no best answer yet', js: true do
      visit question_path(question)

      within ".answer[data-answer-id='#{@answer.id}']" do
        click_on 'Отметить как лучший'
      end

      expect(current_path).to eq question_path(question)

      within ".answer[data-answer-id='#{@answer.id}']" do
        expect(page).to have_content('Лучший ответ')
        expect(page).to_not have_link('Отметить как лучший')
      end
    end

    scenario 'best answer already exists', js: true do
      answer2 = create(:best_answer, question: question, user: user)

      visit question_path(question)

      within ".answer[data-answer-id='#{answer2.id}']" do
        expect(page).to have_content('Лучший ответ')
        expect(page).to_not have_link('Отметить как лучший')
      end

      within ".answer[data-answer-id='#{@answer.id}']" do
        click_on 'Отметить как лучший'

        expect(page).to have_content('Лучший ответ')
        expect(page).to_not have_link('Отметить как лучший')
      end

      expect(current_path).to eq question_path(question)

      within ".answer[data-answer-id='#{answer2.id}']" do
        expect(page).to_not have_content('Лучший ответ')
        expect(page).to have_link('Отметить как лучший')
      end

      within ".answer[data-answer-id='#{@answer.id}']" do
        expect(page).to have_content('Лучший ответ')
        expect(page).to_not have_link('Отметить как лучший')
      end
    end
  end

  context 'Non-authenticated user' do
    scenario 'tries to mark answer as the best', js: true do
      create(:answer, question: question, user: user)

      visit question_path(question)

      expect(page).to_not have_button('Отметить как лучший')
    end
  end
end
