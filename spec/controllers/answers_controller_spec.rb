require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #new' do
    sign_in_user

    let(:question) { create(:question, user: @user) }

    before { get :new, params: { question_id: question } }

    it 'assigns new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    let(:question) { create(:question) }

    context 'with valid attributes' do
      it 'saves new answer' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, user_id: @user } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, user_id: @user }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not saves new answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let(:question) { create(:question, user: @user) }
    let(:answer) { create(:answer, user: @user, question: question) }

    it 'deletes an answer' do
      expect { delete :destroy, params: { id: answer } }.to_not change(@user.answers, :count)
    end

    it 'renders answers index view' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question_path(question)
    end
  end
end
