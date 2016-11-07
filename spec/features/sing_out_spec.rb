require 'rails_helper'

feature 'User sign out', %q{
  In order to be able to end session
  As an user
  I want to be able to sign out
} do

  let(:user) { create(:user) }

  scenario 'Registered user signs out' do
    sign_in(user)

    visit root_path
    click_on 'Выйти'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user tries to sign out' do
    visit root_path

    expect(page).to_not have_link('Выйти')
  end
end
