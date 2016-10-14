FactoryGirl.define do
  factory :question do
    title Faker::Lorem.sentence(3)
    content Faker::Lorem.sentence(6)
  end

  factory :invalid_question, class: 'Question' do
    title nil
    content nil
  end
end
