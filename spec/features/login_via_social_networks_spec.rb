require 'rails_helper'

feature 'Login via social networks', %q{
  In order to fully use website
  As an non-authenticated user
  I want to be able to authenticate via social networks
} do

  context 'Non-authenticated user' do
    context 'via Facebook' do
      it 'successfully signs in with valid credentials' do
        visit '/'
        mock_auth_hash(:facebook)
        click_on 'Войти через Facebook'
        expect(page).to have_content('Выйти')
        expect(page).to_not have_content('Войти через Facebook')
      end

      it 'can not sign in with invalid credentials' do
        OmniAuth.config.mock_auth[:facebook] = :invalid_credentials

        visit '/'
        click_on 'Войти через Facebook'
        expect(page).to have_content('Could not authenticate you from Facebook because "Invalid credentials"')
        expect(page).to have_content('Войти через Facebook')
        expect(page).to_not have_content('Выйти')
      end
    end

    context 'via Twitter' do
      it 'successfully signs in with valid credentials' do
        visit '/'
        mock_auth_hash(:twitter)
        click_on 'Войти через Twitter'
        expect(page).to have_content('Выйти')
        expect(page).to_not have_content('Войти через Twitter')
      end

      it 'can not sign in with invalid credentials' do
        OmniAuth.config.mock_auth[:twitter] = :invalid_credentials

        visit '/'
        click_on 'Войти через Twitter'
        expect(page).to have_content('Could not authenticate you from Twitter because "Invalid credentials"')
        expect(page).to have_content('Войти через Twitter')
        expect(page).to_not have_content('Выйти')
      end
    end
  end
end
