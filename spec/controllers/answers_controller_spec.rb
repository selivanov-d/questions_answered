require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    sign_in_user

    let(:question) { create(:question) }

    context 'with valid attributes' do
      it 'saves new answer' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'saves with association to logged in user' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }.to change(@user.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not saves new answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js } }.to_not change(Answer, :count)
      end

      it 'receives empty response with 204 HTTP-header' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
        expect(response).to have_http_status(:no_content)
        expect(response.body).to eq('')
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let(:question) { create(:question, user: @user) }
    let!(:answer) { create(:answer, user: @user, question: question) }

    context 'questions\'s author' do
      it 'deletes an answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(@user.answers, :count).by(-1)
      end

      it 'receives JSON response with 200 HTTP-header' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to have_http_status(:ok)
        expect(response.body).to have_content('Ваш ответ удалён')
      end
    end

    context 'not questions\'s author' do
      before do
        user2 = create(:user)
        sign_out(@user)
        sign_in(user2)
      end

      it 'does not deletes an answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'receives JSON response with 403 HTTP-header' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to have_content('Удалить можно только свой ответ')
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
          expect(response).to have_http_status(:ok)
          expect(response.body).to have_content('error')
        end
      end
    end

    context 'not questions\'s author' do
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
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to have_content('Отредактировать можно только свой ответ')
      end
    end
  end
end
