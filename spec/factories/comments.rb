FactoryGirl.define do
  factory :comment do
    content { Faker::Lorem.sentence(3) }
    user
    association :commentable, factory: :answer

    factory :invalid_comment, class: 'Answer' do
      content 'no_text'

      factory :invalid_comment_with_subject do
        subject 'answer'
      end
    end

    factory :comment_with_subject do
      subject 'answer'
    end
  end
end
