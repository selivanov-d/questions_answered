require 'rails_helper'

feature 'Edit question', %q{
  In order to change my question phrasing
  As an authenticated user
  I want to be able edit question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  context 'Authenticated user' do
    before :each do
      sign_in(user)

      visit question_path(question)

      click_on 'Редактировать вопрос'
    end

    scenario 'edits question with valid data', js: true do
      within ".question[data-question-id='#{question.id}'] .js-existing-question-edit-form" do
        fill_in 'Title', with: 'Test question'
        fill_in 'Content', with: 'Test question content'
        click_on 'Сохранить'
      end

      expect(current_path).to eq question_path(question)
      expect(page).to have_content('Ваш вопрос успешно изменён')
      expect(page).to have_content('Test question')
      expect(page).to have_content('Test question content')
    end

    scenario 'edits question with invalid data', js: true do
      within ".question[data-question-id='#{question.id}'] .js-existing-question-edit-form" do
        fill_in 'Title', with: ''
        fill_in 'Content', with: ''
        click_on 'Сохранить'
      end

      expect(current_path).to eq question_path(question)
      expect(page).to have_content('[:title] can\'t be blank')
      expect(page).to have_content('[:title] is too short (minimum is 10 characters)')
      expect(page).to have_content('[:content] can\'t be blank')
      expect(page).to have_content('[:content] is too short (minimum is 10 characters)')
    end

    scenario 'creates question with invalid data (title too long)', js: true do
      within ".question[data-question-id='#{question.id}'] .js-existing-question-edit-form" do
        fill_in 'Title', with: 'a' * 256
        fill_in 'Content', with: ''
        click_on 'Сохранить'
      end

      expect(current_path).to eq question_path(question)
      expect(page).to have_content('[:title] is too long (maximum is 255 characters)')
      expect(page).to have_content('[:content] can\'t be blank')
      expect(page).to have_content('[:content] is too short (minimum is 10 characters)')
    end
  end

  context 'Non-authenticated user' do
    scenario 'tries to edit question', js: true do
      question = create(:question)

      visit question_path(question)

      expect(current_path).to eq question_path(question)
      expect(page).to_not have_link 'Редактировать вопрос'
    end
  end
end
