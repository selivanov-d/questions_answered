FactoryGirl.define do
  factory :positive_vote_for_answer, class: 'Vote' do
    user
    positive true
    association :votable, factory: :answer

    factory :negative_vote_for_answer do
      positive false
    end
  end

  factory :positive_vote_for_question, class: 'Vote' do
    user
    positive true
    association :votable, factory: :question

    factory :negative_vote_for_question do
      positive false
    end
  end
end
