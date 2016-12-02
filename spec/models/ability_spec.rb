require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe 'admin' do
    let(:user) { create(:admin) }

    it { should be_able_to :manage, :all }
  end

  describe 'user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    let(:question) { create(:question, user: user) }
    let(:others_question) { create(:question, user: other_user) }

    let(:answer) { create(:answer, user: user, question: question) }
    let(:others_answer) { create(:answer, user: other_user, question: question) }

    let(:attachment_to_question) { create(:question_attachment, attachable: question) }
    let(:others_attachment_to_question) { create(:question_attachment, attachable: others_question) }

    let(:attachment_to_answer) { create(:answer_attachment, attachable: answer) }
    let(:others_attachment_to_answer) { create(:answer_attachment, attachable: others_answer) }

    context 'general' do
      it { should be_able_to :read, :all }
      it { should_not be_able_to :manage, :all }

      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
      it { should be_able_to :me, User }
    end

    context 'owner of question' do
      [:update, :destroy].each do |action|
        it { should be_able_to(action, question) }
        it { should_not be_able_to(action, others_question) }
      end

      it { should be_able_to :vote, others_question }
      it { should_not be_able_to :vote, question }

      it { should be_able_to :mark_as_best, answer }
      it { should be_able_to :mark_as_best, others_answer }

      [:create, :destroy].each do |action|
        it { should be_able_to(action, attachment_to_question) }
        it { should_not be_able_to(action, others_attachment_to_question) }
      end
    end

    context 'owner of answer' do
      [:update, :destroy].each do |action|
        it { should be_able_to(action, answer) }
        it { should_not be_able_to(action, others_answer) }
      end

      it { should be_able_to :vote, others_answer }
      it { should_not be_able_to :vote, answer }

      [:create, :destroy].each do |action|
        it { should be_able_to(action, attachment_to_answer) }
        it { should_not be_able_to(action, others_attachment_to_answer) }
      end
    end
  end
end
