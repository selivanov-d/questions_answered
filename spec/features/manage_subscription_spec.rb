require 'rails_helper'

feature 'Manage subscription', %q{
  In order to manage notifications about new answers for a question that i'm interested in
  As an authenticated user
  I want to be able to create and delete subscription
} do

  let!(:user) { create(:user) }
  let!(:question) { create(:question) }

  context 'When authenticated' do
    context 'when not subscribed' do
      before :each do
        sign_in(user)

        visit question_path(question)
      end

      scenario 'user creates subscription', js: true do
        click_on 'Подписаться'

        expect(current_path).to eq question_path(question)
        expect(page).to have_content('Отписаться')
        expect(page).to_not have_content('Подписаться')
      end

      scenario 'user can not delete subscription' do
        expect(page).to_not have_content('Отписаться')
      end
    end

    context 'when subscribed' do
      let!(:subscription) { create(:subscription, question: question, user: user) }
      let(:answer_giver) { create(:user) }

      before :each do |example|
        unless example.metadata[:skip_before]
          sign_in(user)
          visit question_path(question)
        end
      end

      scenario 'user receives email notification about new answer', skip_before: true, js: true do
        sign_in(answer_giver)

        visit question_path(question)

        clear_emails

        within '.js-new-answer-for-question-form' do
          fill_in 'Content', with: 'Test answer content'
          click_on 'Сохранить ответ'
        end

        sleep 1

        open_email(subscription.user.email)

        expect(current_email).to have_content 'Test answer content'
      end

      scenario 'user can delete subscription', js: true do
        click_on 'Отписаться'

        expect(current_path).to eq question_path(question)
        expect(page).to have_content('Подписаться')
        expect(page).to_not have_content('Отписаться')
      end

      scenario 'user can not create subscription second time' do
        expect(page).to_not have_content('Подписаться')
      end
    end
  end

  context 'When unauthenticated' do
    scenario 'user can not create subscription' do
      visit question_path(question)

      expect(current_path).to eq question_path(question)
      expect(page).to_not have_link('Подписаться')
    end

    scenario 'user can not delete subscription' do
      visit question_path(question)

      expect(current_path).to eq question_path(question)
      expect(page).to_not have_link('Отписаться')
    end
  end
end
