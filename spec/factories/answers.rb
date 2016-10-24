FactoryGirl.define do
  factory :answer do
    content { Faker::Lorem.sentence(6) }
    question
    user
    best false

    factory :best_answer do
      best true
    end
  end

  factory :invalid_answer, class: 'Answer' do
    content nil
    association :question, factory: :invalid_question
    user
  end
end
