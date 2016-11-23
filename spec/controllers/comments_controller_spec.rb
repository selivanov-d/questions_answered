require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    context 'with valid attributes' do
      sign_in_user

      let(:answer) { create(:answer) }

      before :each do
        post :create, params: { comment: attributes_for(:comment), answer_id: answer }
      end

      it 'assigns new Comment to @comment' do
        expect(assigns(:comment)).to eq(Comment.last)
      end

      it 'assigns requested commentable to @commentable' do
        expect(assigns(:commentable)).to eq(answer)
      end

      it 'saves new comment attached to user' do
        expect { post :create, params: { comment: attributes_for(:comment), answer_id: answer } }.to change(@user.comments, :count).by(1)
      end

      it 'saves new comment attached to commentable' do
        expect { post :create, params: { comment: attributes_for(:comment), answer_id: answer } }.to change(answer.comments, :count).by(1)
      end

      it 'receives JSON response with 200 HTTP-header' do
        success_response_json = {
          status: 'success',
          data: {
            message: 'Ваш коммент сохранён',
            comment: assigns(:comment)
          }
        }.to_json

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(success_response_json)
      end
    end

    context 'with invalid attributes' do
      sign_in_user

      let(:answer) { create(:answer) }

      before do |example|
        unless example.metadata[:skip_before]
          post :create, params: { comment: attributes_for(:invalid_comment), answer_id: answer }
        end
      end

      it 'does not saves new question', skip_before: true do
        expect { post :create, params: { comment: attributes_for(:invalid_comment), answer_id: answer } }.to_not change(Comment, :count)
      end

      it 'receives JSON response with 200 HTTP-header' do
        error_response_json = {
          status: 'error',
          data: assigns(:comment).errors
        }.to_json

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(error_response_json)
      end
    end
  end
end
