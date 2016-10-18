require 'rails_helper'

def destroy_session_and_check_result
  page.driver.submit :delete, destroy_user_session_path, {}

  expect(page).to have_content 'Signed out successfully.'
  expect(current_path).to eq root_path
end

feature 'User sign out', %q{
  In order to be able to end session
  As an user
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Registered user signs out' do
    sign_in(user)

    destroy_session_and_check_result
  end

  scenario 'Non-registered user tries to sign out' do
    destroy_session_and_check_result
  end
end
