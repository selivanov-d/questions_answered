require 'rails_helper'

feature 'Search', %q{
  In order to find information that i need
  As a user
  I want to be able to perform a search
} do

  let!(:right_question) { create(:question, content: 'Intro text. Precious question text. Outro text.') }
  let!(:right_answer) { create(:answer, content: 'Intro text. Precious answer text. Outro text.') }
  let!(:right_comment) { create(:comment_for_question, content: 'Intro text. Precious comment text. Outro text.') }

  let!(:wrong_question) { create(:question, content: 'Intro text. Useless question text. Outro text.') }
  let!(:wrong_answer) { create(:answer, content: 'Intro text. Useless answer text. Outro text.') }
  let!(:wrong_comment) { create(:comment_for_question, content: 'Intro text. Useless comment text. Outro text.') }

  before :each do
    index
    visit searches_path
  end

  context 'when searching for existing string' do
    context 'globally' do
      it 'should return list of all questions which pages contains searchable string', sphinx: true do
        within '.search-form' do
          fill_in 'Что', with: 'Precious'

          click_on 'Найти'
        end

        expect(current_path).to eq searches_path

        within '.search-results' do
          expect(page).to have_content(right_question.title)
          expect(page).to have_content(right_answer.question.title)
          expect(page).to have_content(right_comment.commentable.title)

          expect(page).to_not have_content(wrong_question.title)
          expect(page).to_not have_content(wrong_answer.question.title)
          expect(page).to_not have_content(wrong_comment.commentable.title)
        end
      end
    end

    context 'only in questions' do
      it 'should return only one result', sphinx: true do
        within '.search-form' do
          select 'В вопросах', from: 'Где'

          fill_in 'Что', with: 'Precious question text'

          click_on 'Найти'
        end

        expect(current_path).to eq searches_path

        within '.search-results' do
          expect(page).to have_content(right_question.title)
          expect(page).to_not have_content(right_answer.question.title)
          expect(page).to_not have_content(right_comment.commentable.title)

          expect(page).to_not have_content(wrong_question.title)
          expect(page).to_not have_content(wrong_answer.question.title)
          expect(page).to_not have_content(wrong_comment.commentable.title)
        end
      end
    end

    context 'only in answers' do
      it 'should return only one result', sphinx: true do
        within '.search-form' do
          select 'В ответах', from: 'Где'

          fill_in 'Что', with: 'Precious answer text'

          click_on 'Найти'
        end

        expect(current_path).to eq searches_path

        within '.search-results' do
          expect(page).to have_content(right_answer.question.title)
          expect(page).to_not have_content(right_question.title)
          expect(page).to_not have_content(right_comment.commentable.title)

          expect(page).to_not have_content(wrong_question.title)
          expect(page).to_not have_content(wrong_answer.question.title)
          expect(page).to_not have_content(wrong_comment.commentable.title)
        end
      end
    end

    context 'only in comments' do
      it 'should return only one result', sphinx: true do
        within '.search-form' do
          select 'В комментариях', from: 'Где'

          fill_in 'Что', with: 'Precious comment text'

          click_on 'Найти'
        end

        expect(current_path).to eq searches_path

        within '.search-results' do
          expect(page).to have_content(right_comment.commentable.title)
          expect(page).to_not have_content(right_answer.question.title)
          expect(page).to_not have_content(right_question.title)

          expect(page).to_not have_content(wrong_question.title)
          expect(page).to_not have_content(wrong_answer.question.title)
          expect(page).to_not have_content(wrong_comment.commentable.title)
        end
      end
    end
  end

  context 'when searching for non-existing string' do
    it 'should not return any results', sphinx: true do
      within '.search-form' do
        fill_in 'Что', with: 'Some random string'

        click_on 'Найти'
      end

      expect(page).to_not have_selector('.search-results')
    end
  end

  context 'when entering invalid query' do
    it 'should not return any results and should display validation errors', sphinx: true do
      within '.search-form' do
        fill_in 'Что', with: ''

        click_on 'Найти'
      end

      expect(page).to have_content('[:query] can\'t be blank')
      expect(page).to have_content('[:query] is too short (minimum is 3 characters)')
    end
  end
end
