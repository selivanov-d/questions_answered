FactoryGirl.define do
  factory :comment do
    content { Faker::Lorem.sentence(3) }
    user
    association :commentable, factory: :answer
    subject 'answer'

    factory :invalid_comment, class: 'Answer' do
      content 'no_text'
    end
  end
end
