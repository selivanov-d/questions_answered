require 'rails_helper'

feature 'Questions daily digest', %q{
  In order to be notified about new questions
  As a user
  I want to receive list of questions created for a last day via email
} do

  let!(:user) { create(:user) }
  let!(:questions) { create_list(:one_day_old_question, 2) }

  scenario 'User receives email with all questions' do
    clear_emails

    QuestionsDigestJob.perform_now

    open_email(user.email)

    questions.each do |question|
      expect(current_email).to have_link(question.title)
    end
  end
end
