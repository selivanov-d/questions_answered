FactoryGirl.define do
  factory :positive_vote_for_answer, class: 'Vote' do
    user
    value 1
    association :votable, factory: :answer

    factory :negative_vote_for_answer do
      value -1
    end
  end

  factory :positive_vote_for_question, class: 'Vote' do
    user
    value 1
    association :votable, factory: :question

    factory :negative_vote_for_question do
      value -1
    end
  end
end
