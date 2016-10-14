FactoryGirl.define do
  factory :answer do
    content Faker::Lorem.sentence(6)
    question
  end

  factory :invalid_answer, class: 'Answer' do
    content nil
    association :question, factory: :invalid_question
  end
end
