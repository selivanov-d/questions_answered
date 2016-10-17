require 'rails_helper'

feature 'Index questions', %q{
  In order to select a question to give an answer
  As an authenticated user
  I want to be able to view list of questions
} do

  given(:questions) { create_list(:question, 5) }
  given(:user) { create(:user) }

  scenario 'Authenticated user views list of questions' do
    sign_in(user)

    visit questions_path(questions: questions)

    expect(page).to have_selector('.js-question', count: 5)
    expect(page).to have_selector('a.js-give-answer', count: 5)

    first(:css, 'a.js-give-answer').click
    # Review: наверное, можно привязаться к разметке (искать все ссылки с определённым классом или в блоке с определённым классом), но это всё слишком изменчиво. К тексту привязываться тоже как-то странно, ибо он тоже много раз поменяется. Так что пока только завязка на элемент и текст в нём.
    # Review: кстати, можно ли использовать i18n в тестах?

    fill_in 'Content', with: 'Dummy answer content.'
    click_on 'Сохранить'

    question = questions[0]

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Ваш ответ сохранён'
  end

  scenario 'Non-authenticated user views list of questions' do
    visit questions_path(questions: questions)

    expect(page).to have_selector('.js-question', count: 5)
    expect(page).to have_selector('a.js-give-answer', count: 0)
  end
end
