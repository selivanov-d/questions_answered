require 'rails_helper'
require 'shared_examples/controllers/voted_spec'

RSpec.describe AnswersController, type: :controller do
  it_should_behave_like 'voted'

  describe 'POST #create' do
    sign_in_user

    let(:question) { create(:question) }

    context 'with valid attributes' do
      before :each do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
      end

      it 'assigns new answer to @answer' do
        expect(assigns(:answer)).to eq(Answer.last)
      end

      it 'assigns parent question to @question' do
        expect(assigns(:question)).to eq(question)
      end

      it 'saves new answer' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'saves with association to logged in user' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }.to change(@user.answers, :count).by(1)
      end

      it 'receives JSON response with 200 HTTP-header' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_content('success')
        expect(response.body).to have_content('Ваш ответ сохранён')
      end
    end

    context 'with invalid attributes' do
      before :each do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
      end

      it 'assigns parent question to @question' do
        expect(assigns(:question)).to eq(question)
      end

      it 'does not saves new answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js } }.to_not change(Answer, :count)
      end

      it 'receives JSON response with 200 HTTP-header' do
        error_response_json = {
          status: 'error',
          data: assigns(:answer).errors
        }.to_json

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq error_response_json
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let(:question) { create(:question, user: @user) }
    let!(:answer) { create(:answer, user: @user, question: question) }

    context 'questions\'s author' do
      it 'assigns requested answer to @answer' do
        delete :destroy, params: { id: answer }, format: :js
        expect(assigns(:answer)).to eq(answer)
      end

      it 'deletes an answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(@user.answers, :count).by(-1)
      end

      it 'receives JSON response with 200 HTTP-header' do
        delete :destroy, params: { id: answer }, format: :js

        success_response_json = {
          status: 'success',
          data: {
            message: 'Ваш ответ удалён'
          }
        }.to_json

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq success_response_json
      end
    end

    context 'not questions\'s author' do
      before do
        user2 = create(:user)
        sign_out(@user)
        sign_in(user2)
      end

      it 'assigns requested answer to @answer' do
        delete :destroy, params: { id: answer }, format: :js
        expect(assigns(:answer)).to eq(answer)
      end

      it 'does not deletes an answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'receives JSON response with 403 HTTP-header' do
        delete :destroy, params: { id: answer }, format: :js

        error_response_json = {
          message: 'Удалить можно только свой ответ'
        }.to_json

        expect(response).to have_http_status(:forbidden)
        expect(response.body).to eq error_response_json
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    let!(:question) { create(:question, user: @user) }
    let!(:answer) { create(:answer, user: @user, question: question) }

    context 'answer\'s author' do
      context 'with valid attribures' do
        before do
          patch :update, params: { id: answer, question_id: question, answer: { content: 'New answer body' } }, format: :js
        end

        it 'assigns requested answer to @answer' do
          expect(assigns(:answer)).to eq(answer)
        end

        it 'changes answer\'s attributes' do
          answer.reload
          expect(answer.content).to eq 'New answer body'
        end

        it 'receives JSON response with 200 HTTP-header' do
          expect(response).to have_http_status(:ok)
          expect(response.body).to have_content('success')
          expect(response.body).to have_content('Ваш ответ успешно изменён')
        end
      end

      context 'with invalid attributes' do
        before do
          patch :update, params: { id: answer, question_id: question, answer: { content: '' } }, format: :js
        end

        it 'assigns requested answer to @answer' do
          expect(assigns(:answer)).to eq(answer)
        end

        it 'does not updates an answer' do
          answer.reload
          expect(answer.content).to_not eq ''
        end

        it 'receives JSON response with 200 HTTP-header' do
          error_response_json = {
            status: 'error',
            data: assigns(:answer).errors
          }.to_json

          expect(response).to have_http_status(:ok)
          expect(response.body).to eq error_response_json
        end
      end
    end

    context 'not answer\'s author' do
      before do
        user2 = create(:user)
        sign_out(@user)
        sign_in(user2)

        patch :update, params: { id: answer, question_id: question, answer: { content: 'New answer body' } }, format: :js
      end

      it 'assigns requested answer to @answer' do
        expect(assigns(:answer)).to eq(answer)
      end

      it 'does not updates an answer' do
        answer.reload
        expect(answer.content).to_not eq 'New answer body'
      end

      it 'receives JSON response with 403 HTTP-header' do
        error_response_json = {
          message: 'Отредактировать можно только свой ответ'
        }.to_json

        expect(response).to have_http_status(:forbidden)
        expect(response.body).to eq error_response_json
      end
    end
  end

  describe 'PATCH #mark_as_best' do
    sign_in_user

    let!(:question) { create(:question, user: @user) }
    let!(:answer) { create(:answer, user: @user, question: question) }

    context 'question\'s author' do
      before do
        patch :mark_as_best, params: { id: answer }, format: :js
      end

      it 'assigns requested answer to @answer' do
        expect(assigns(:answer)).to eq(answer)
      end

      it 'changes answer\'s attributes' do
        answer.reload
        expect(answer.best).to eq true
      end

      it 'receives JSON response with 200 HTTP-header' do
        success_response_json = {
          status: 'success',
          data: 'Ответ отмечен как лучший'
        }.to_json

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq success_response_json
      end
    end

    context 'not question\'s author' do
      before do
        user2 = create(:user)
        question2 = create(:question, user: user2)
        @answer2 = create(:answer, question: question2, user: user2)

        patch :mark_as_best, params: { id: @answer2 }, format: :js
      end

      it 'assigns requested answer to @answer' do
        expect(assigns(:answer)).to eq(@answer2)
      end

      it 'does not changes answer\'s attributes' do
        @answer2.reload
        expect(@answer2.best).to eq false
      end

      it 'receives JSON response with 403 HTTP-header' do
        errors_response_json = {
          message: 'Отметить ответ лучшим можно у своего вопроса'
        }.to_json

        expect(response).to have_http_status(:forbidden)
        expect(response.body).to eq errors_response_json
      end
    end
  end
end
