FactoryGirl.define do
  factory :question do
    title { Faker::Lorem.sentence(3) }
    content { Faker::Lorem.sentence(6) }
    user

    factory :question_with_answers do
      transient do
        answers_count 5
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end

    factory :one_day_old_question do
      created_at { Date.yesterday }
    end
  end

  factory :invalid_question, class: 'Question' do
    title nil
    content nil
  end
end
