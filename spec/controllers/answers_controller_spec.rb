require 'rails_helper'
require 'shared_examples/controllers/voted'

RSpec.describe AnswersController, type: :controller do
  it_should_behave_like 'voted'

  describe 'POST #create' do
    sign_in_user

    let(:question) { create(:question) }

    context 'with valid attributes' do
      before :each do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :json }
      end

      it 'assigns new answer to @answer' do
        expect(assigns(:answer)).to eq(Answer.last)
      end

      it 'assigns parent question to @question' do
        expect(assigns(:question)).to eq(question)
      end

      it 'saves new answer' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :json } }.to change(question.answers, :count).by(1)
      end

      it 'saves with association to logged in user' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :json } }.to change(@user.answers, :count).by(1)
      end

      it 'receives response with 200 HTTP-header' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      before :each do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :json }
      end

      it 'assigns parent question to @question' do
        expect(assigns(:question)).to eq(question)
      end

      it 'does not saves new answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :json } }.to_not change(Answer, :count)
      end

      it 'receives JSON response with 200 HTTP-header' do
        error_response_json = {
          errors: assigns(:answer).errors
        }.to_json

        expect(response).to have_http_status(:unprocessable_entity)
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
        delete :destroy, params: { id: answer }, format: :json
        expect(assigns(:answer)).to eq(answer)
      end

      it 'deletes an answer' do
        expect { delete :destroy, params: { id: answer }, format: :json }.to change(@user.answers, :count).by(-1)
      end

      it 'receives JSON response with 200 HTTP-header' do
        delete :destroy, params: { id: answer }, format: :json

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'not questions\'s author' do
      before do
        user2 = create(:user)
        sign_out(@user)
        sign_in(user2)
      end

      it 'assigns requested answer to @answer' do
        delete :destroy, params: { id: answer }, format: :json
        expect(assigns(:answer)).to eq(answer)
      end

      it 'does not deletes an answer' do
        expect { delete :destroy, params: { id: answer }, format: :json }.to_not change(Answer, :count)
      end

      it 'receives JSON response with 403 HTTP-header' do
        delete :destroy, params: { id: answer }, format: :json

        expect(response).to have_http_status(:forbidden)
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
          patch :update, params: { id: answer, question_id: question, answer: { content: 'New answer body' } }, format: :json
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
        end
      end

      context 'with invalid attributes' do
        before do
          patch :update, params: { id: answer, question_id: question, answer: { content: '' } }, format: :json
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
            errors: assigns(:answer).errors
          }.to_json

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq error_response_json
        end
      end
    end

    context 'not answer\'s author' do
      before do
        user2 = create(:user)
        sign_out(@user)
        sign_in(user2)

        patch :update, params: { id: answer, question_id: question, answer: { content: 'New answer body' } }, format: :json
      end

      it 'assigns requested answer to @answer' do
        expect(assigns(:answer)).to eq(answer)
      end

      it 'does not updates an answer' do
        answer.reload
        expect(answer.content).to_not eq 'New answer body'
      end

      it 'receives response with 403 HTTP-header' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PATCH #mark_as_best' do
    sign_in_user

    let!(:question) { create(:question, user: @user) }
    let!(:answer) { create(:answer, user: @user, question: question) }

    context 'question\'s author' do
      before do
        patch :mark_as_best, params: { id: answer }, format: :json
      end

      it 'assigns requested answer to @answer' do
        expect(assigns(:answer)).to eq(answer)
      end

      it 'changes answer\'s attributes' do
        answer.reload
        expect(answer.best).to eq true
      end

      it 'receives JSON response with 200 HTTP-header' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'not question\'s author' do
      before do
        user2 = create(:user)
        question2 = create(:question, user: user2)
        @answer2 = create(:answer, question: question2, user: user2)

        patch :mark_as_best, params: { id: @answer2 }, format: :json
      end

      it 'assigns requested answer to @answer' do
        expect(assigns(:answer)).to eq(@answer2)
      end

      it 'does not changes answer\'s attributes' do
        @answer2.reload
        expect(@answer2.best).to eq false
      end

      it 'receives JSON response with 403 HTTP-header' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
