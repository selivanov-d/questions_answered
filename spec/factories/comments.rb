FactoryGirl.define do
  factory :comment do
    content { Faker::Lorem.sentence(3) }
    user
    association :commentable, factory: :answer
  end
end