require 'rails_helper'

def fill_and_submit_register_form
  visit new_user_registration_path

  fill_in 'Email', with: demo_user.email
  fill_in 'Password', with: demo_user.password
  fill_in 'Password confirmation', with: demo_user.password

  click_on 'Sign up'
end

feature 'User registration', %q{
  In order to be able to log in
  As an non-registered user
  I want to be able to register
} do

  let(:demo_user) { build(:demo_user) }

  scenario 'Non-registered user tries to register' do
    fill_and_submit_register_form

    expect(current_path).to eq root_path
    expect(page).to have_content('Welcome! You have signed up successfully.')
  end

  scenario 'Registered user tries to register' do
    demo_user.save

    fill_and_submit_register_form

    expect(current_path).to eq user_registration_path
    expect(page).to have_content('Email has already been taken')
  end
end
