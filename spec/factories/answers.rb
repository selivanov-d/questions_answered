FactoryGirl.define do
  factory :answer do
    content { Faker::Lorem.sentence(6) }
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    content nil
    association :question, factory: :invalid_question
    user
  end
end
