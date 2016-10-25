require 'rails_helper'

feature 'Mark answer as best', %q{
  In order to pick answer that resolved my problem and to praise user who gave it
  As an authenticated user
  I want to be able to mark answer as the best
} do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  context 'Authenticated user marks answer as the best' do
    before do
      sign_in(user)

      @question = create(:question, user: user)
      @answer = create(:answer, question: @question, user: user)
    end

    scenario 'there is no best answer yet', js: true do
      visit question_path(@question)

      within ".answer[data-answer-id='#{@answer.id}']" do
        click_on 'Отметить как лучший'
      end

      expect(current_path).to eq question_path(@question)

      within ".answer[data-answer-id='#{@answer.id}']" do
        expect(page).to have_content('Лучший ответ')
        expect(page).to_not have_link('Отметить как лучший')
      end
    end

    scenario 'best answer already exists', js: true do
      answer2 = create(:answer, question: @question, user: user)
      answer2.mark_as_best
      answer2.save
      answer2.reload

      visit question_path(@question)

      within ".answer[data-answer-id='#{answer2.id}']" do
        expect(page).to have_content('Лучший ответ')
        expect(page).to_not have_link('Отметить как лучший')
      end

      within ".answer[data-answer-id='#{@answer.id}']" do
        click_on 'Отметить как лучший'

        expect(page).to have_content('Лучший ответ')
      end

      expect(current_path).to eq question_path(@question)

      within ".answer[data-answer-id='#{answer2.id}']" do
        expect(page).to_not have_content('Лучший ответ')
        expect(page).to have_link('Отметить как лучший')
      end
    end
  end

  context 'Non-authenticated user' do
    before do
      @question = create(:question, user: user)
      @answer = create(:answer, question: question, user: user)

      visit question_path(question)
    end

    scenario 'tries to mark answer as the best', js: true do
      visit question_path(question)

      expect(page).to_not have_button('Отметить как лучший')
    end
  end
end
