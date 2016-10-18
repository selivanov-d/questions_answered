FactoryGirl.define do

  factory :user do
    email { Faker::Internet.email }
    password '123456789'
    password_confirmation '123456789'

    factory :demo_user do
      email 'demo_user@domain.com'
    end
  end
end
