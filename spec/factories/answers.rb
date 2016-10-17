FactoryGirl.define do
  sequence :answer_content do
    Faker::Lorem.sentence(6)
  end

  factory :answer do
    content :answer_content
    question
  end

  factory :invalid_answer, class: 'Answer' do
    content nil
    association :question, factory: :invalid_question
  end
end
