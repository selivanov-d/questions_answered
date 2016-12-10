require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    context 'with valid attributes' do
      sign_in_user

      let(:answer) { create(:answer) }

      before :each do
        post :create, params: { comment: attributes_for(:comment_with_subject), answer_id: answer }, format: :json
      end

      it 'assigns new Comment to @comment' do
        expect(assigns(:comment)).to eq(Comment.last)
      end

      it 'assigns requested commentable to @commentable' do
        expect(assigns(:commentable)).to eq(answer)
      end

      it 'saves new comment attached to user' do
        expect { post :create, params: { comment: attributes_for(:comment_with_subject), answer_id: answer }, format: :json }.to change(@user.comments, :count).by(1)
      end

      it 'saves new comment attached to commentable' do
        expect { post :create, params: { comment: attributes_for(:comment_with_subject), answer_id: answer }, format: :json }.to change(answer.comments, :count).by(1)
      end

      it 'receives response with 200 HTTP-header' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      sign_in_user

      let(:answer) { create(:answer) }

      before do |example|
        unless example.metadata[:skip_before]
          post :create, params: { comment: attributes_for(:invalid_comment_with_subject), answer_id: answer }, format: :json
        end
      end

      it 'assigns requested commentable to @commentable' do
        expect(assigns(:commentable)).to eq(answer)
      end

      it 'does not saves new question', skip_before: true do
        expect { post :create, params: { comment: attributes_for(:invalid_comment_with_subject), answer_id: answer }, format: :json }.to_not change(Comment, :count)
      end

      it 'receives JSON response with 200 HTTP-header' do
        error_response_json = {
          errors: assigns(:comment).errors
        }.to_json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq(error_response_json)
      end
    end
  end
end
