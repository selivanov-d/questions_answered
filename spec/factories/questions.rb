FactoryGirl.define do
  sequence :question_title do
    Faker::Lorem.sentence(3)
  end

  sequence :question_content do
    Faker::Lorem.sentence(6)
  end

  # REVIEW: почему create_list создаёт одинаковые данные для моделей? Имею ввиду, что в списке вопросов все названия и тексты одинковые независимо от того, сколько моделей я создаю.
  factory :question do
    title :question_title
    content :question_content

    factory :question_with_answers do
      transient do
        answers_count 5
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end
  end

  factory :invalid_question, class: 'Question' do
    title nil
    content nil
  end
end
