require 'rails_helper'

feature 'Search', %q{
  In order to find information that i need
  As a user
  I want to be able to perform a search
} do

  let!(:right_question) { create(:question, content: 'Intro text. Precious question text. Outro text.') }
  let!(:right_answer) { create(:answer, question: right_question, content: 'Intro text. Precious answer text. Outro text.') }
  let!(:right_comment) { create(:comment, commentable: right_question, content: 'Intro text. Precious comment text. Outro text.') }

  let!(:wrong_question) { create(:question, content: 'Intro text. Useless question text. Outro text.') }
  let!(:wrong_answer) { create(:answer, question: wrong_question, content: 'Intro text. Useless answer text. Outro text.') }
  let!(:wrong_comment) { create(:comment, commentable: wrong_question, content: 'Intro text. Useless comment text. Outro text.') }

  before :each do
    index
    visit searches_path
  end

  context 'when searching for existing string' do
    context 'globally', sphinx: true do
      it 'should return list of all entities that contains searchable string' do
        within '.search-form' do
          fill_in 'Найти', with: 'Precious'

          click_on 'Найти'
        end

        expect(current_path).to eq searches_path

        within '.search-results' do
          expect(page).to have_content('Precious question text')
          expect(page).to have_content('Precious answer text')
          expect(page).to have_content('Precious comment text')

          expect(page).to_not have_content('Useless question text')
          expect(page).to_not have_content('Useless answer text')
          expect(page).to_not have_content('Useless comment text')
        end
      end
    end

    context 'only in questions', sphinx: true do
      it 'should return only one result' do
        within '.search-form' do
          select 'В вопросах', from: 'в'

          fill_in 'Найти', with: 'Precious question text'

          click_on 'Найти'
        end

        expect(current_path).to eq searches_path

        within '.search-results' do
          expect(page).to have_content('Precious question text')
          expect(page).to_not have_content('Precious answer text')
          expect(page).to_not have_content('Precious comment text')

          expect(page).to_not have_content('Useless question text')
          expect(page).to_not have_content('Useless answer text')
          expect(page).to_not have_content('Useless comment text')
        end
      end
    end

    context 'only in answers', sphinx: true do
      it 'should return only one result' do
        within '.search-form' do
          select 'В ответах', from: 'в'

          fill_in 'Найти', with: 'Precious answer text'

          click_on 'Найти'
        end

        expect(current_path).to eq searches_path

        within '.search-results' do
          expect(page).to have_content('Precious answer text')
          expect(page).to have_content('Precious question text')
          expect(page).to_not have_content('Precious comment text')

          expect(page).to_not have_content('Useless question text')
          expect(page).to_not have_content('Useless answer text')
          expect(page).to_not have_content('Useless comment text')
        end
      end
    end

    context 'only in comments', sphinx: true do
      it 'should return only one result' do
        within '.search-form' do
          select 'В комментариях', from: 'в'

          fill_in 'Найти', with: 'Precious comment text'

          click_on 'Найти'
        end

        expect(current_path).to eq searches_path

        within '.search-results' do
          expect(page).to have_content('Precious comment text')
          expect(page).to have_content('Precious question text')
          expect(page).to_not have_content('Precious answer text')

          expect(page).to_not have_content('Useless question text')
          expect(page).to_not have_content('Useless answer text')
          expect(page).to_not have_content('Useless comment text')
        end
      end
    end
  end

  context 'when searching for non-existing string' do
    it 'should not return any results' do
      within '.search-form' do
        fill_in 'Найти', with: 'Some random string'

        click_on 'Найти'
      end

      expect(page).to_not have_selector('.search-results')
    end
  end
end
