require 'rails_helper'

feature 'User registration', %q{
  In order to be able to log in
  As an non-registered user
  I want to be able to register
} do

  scenario 'Non-registered user tries to register' do
    visit new_user_registration_path

    fill_in 'Email', with: 'portwine72@gmail.com'
    fill_in 'Password', with: 'edgeofsanity'
    fill_in 'Password confirmation', with: 'edgeofsanity'

    click_on 'Sign up'

    expect(current_path).to eq root_path
    expect(page).to have_content('Welcome! You have signed up successfully.')
  end

  scenario 'Registered user tries to register' do
    create(:defined_user)

    visit new_user_registration_path

    fill_in 'Email', with: 'demo_user@domain.com'
    fill_in 'Password', with: '123456789'
    fill_in 'Password confirmation', with: '123456789'

    click_on 'Sign up'

    expect(current_path).to eq user_registration_path
    expect(page).to have_content('Email has already been taken')
  end
end
