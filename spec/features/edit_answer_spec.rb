require 'rails_helper'

feature 'Edit answer', %q{
  In order to change my answer phrasing
  As an authenticated user
  I want to be able edit answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  context 'Authenticated author' do
    before :each do
      sign_in(user)

      @answer = create(:answer, question: question, user: user)
      @answer_attachment = create(:answer_attachment, attachable: @answer)

      visit question_path(question)
    end

    scenario 'edits answer with valid data', js: true do
      within ".answer[data-answer-id='#{@answer.id}']" do
        click_on('Редактировать ответ')

        fill_in 'Content', with: 'Valid answer content'

        click_on 'Добавить файл'
        file_input = all('input[type="file"]')
        file_input[0].set(Rails.root + 'spec/support/files/image.jpg')

        click_on 'Сохранить'
      end

      expect(current_path).to eq question_path(question)
      expect(page).to have_content('Ваш ответ успешно изменён')
      expect(page).to have_content('Valid answer content')
      expect(page).to have_content('image.jpg')
    end

    scenario 'edits answer with invalid data', js: true do
      within ".answer[data-answer-id='#{@answer.id}']" do
        click_on('Редактировать ответ')

        fill_in 'Content', with: ''

        click_on 'Добавить файл'
        file_input = all('input[type="file"]')
        file_input[0].set(Rails.root + 'spec/support/files/image.jpg')

        click_on 'Сохранить'
      end

      expect(current_path).to eq question_path(question)
      expect(page).to have_content('[:content] can\'t be blank')
      expect(page).to have_content('[:content] is too short (minimum is 10 characters)')
      expect(page).to_not have_content('image.jpg')
    end

    scenario 'removes attachment from answer', js: true do
      within ".js-answer[data-answer-id='#{@answer.id}']" do
        click_on('Редактировать ответ')

        within '.js-existing-answer-edit-form' do
          find("a[href='#{attachment_path(@answer_attachment)}']").click
        end
      end

      expect(page).to_not have_content('test-file.jpg')
    end
  end

  context 'Authenticated non-author' do
    before :each do
      @answer = create(:answer, question: question, user: user)

      user2 = create(:user)
      sign_in(user2)

      visit question_path(question)
    end

    scenario 'tries to edit answer', js: true do
      within ".answer[data-answer-id='#{@answer.id}']" do
        expect(page).to_not have_link('Редактировать ответ')
      end
    end
  end

  context 'Non-authenticated user' do
    scenario 'tries to edit answer' do
      @answer = create(:answer, question: question, user: user)

      visit question_path(question)

      expect(current_path).to eq question_path(question)
      expect(page).to_not have_link('Редактировать ответ')
    end
  end
end
