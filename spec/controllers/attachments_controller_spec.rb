require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    sign_in_user

    let!(:question) { create(:question, user: @user) }
    let!(:answer) { create(:answer, question: question, user: @user) }
    let!(:question_attachment) { create(:question_attachment, attachable: question) }
    let!(:answer_attachment) { create(:answer_attachment, attachable: answer) }

    context 'question\'s author' do
      before do |example|
        unless example.metadata[:skip_before]
          delete :destroy, params: { id: question_attachment }, format: :js
        end
      end

      it 'assigns requested attachment to @attachment' do
        expect(assigns(:attachment)).to eq(question_attachment)
      end

      it 'deletes a question', :skip_before do
        expect { delete :destroy, params: { id: question_attachment }, format: :js }.to change(question.attachments, :count).by(-1)
      end

      it 'returns JSON response with 200 HTTP-status' do
        success_response_json = {
          status: 'success',
          data: {
            message: 'Приложение удалено'
          }
        }.to_json

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq success_response_json
      end
    end

    context 'answer\'s author' do
      before do |example|
        unless example.metadata[:skip_before]
          delete :destroy, params: { id: question_attachment }, format: :js
        end
      end

      it 'assigns requested attachment to @attachment' do
        delete :destroy, params: { id: answer_attachment }
        expect(assigns(:attachment)).to eq(answer_attachment)
      end

      it 'deletes a question', :skip_before do
        expect { delete :destroy, params: { id: answer_attachment } }.to change(answer.attachments, :count).by(-1)
      end

      it 'returns JSON response with 200 HTTP-status' do
        success_response_json = {
          status: 'success',
          data: {
            message: 'Приложение удалено'
          }
        }.to_json

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq success_response_json
      end
    end

    context 'not question\'s author' do
      before :each do
        user2 = create(:user)
        sign_out(@user)
        sign_in(user2)
      end

      before :each do |example|
        unless example.metadata[:skip_before]
          delete :destroy, params: { id: question_attachment }, format: :js
        end
      end

      it 'does not deletes an attachment', :skip_before do
        expect { delete :destroy, params: { id: question_attachment } }.to_not change(Attachment, :count)
      end

      it 'returns JSON response with 403 HTTP-status' do
        success_response_json = {
          status: 'error',
          data: {
            message: 'Удалить можно только приложение у своего вопроса или ответа'
          }
        }.to_json

        expect(response).to have_http_status(:forbidden)
        expect(response.body).to eq success_response_json
      end
    end

    context 'not answer\'s author' do
      before do
        user2 = create(:user)
        sign_out(@user)
        sign_in(user2)
      end

      before :each do |example|
        unless example.metadata[:skip_before]
          delete :destroy, params: { id: question_attachment }, format: :js
        end
      end

      it 'does not deletes an attachment', :skip_before do
        expect { delete :destroy, params: { id: answer_attachment } }.to_not change(Attachment, :count)
      end

      it 'returns JSON response with 403 HTTP-status' do
        success_response_json = {
          status: 'error',
          data: {
            message: 'Удалить можно только приложение у своего вопроса или ответа'
          }
        }.to_json

        expect(response).to have_http_status(:forbidden)
        expect(response.body).to eq success_response_json
      end
    end
  end
end
