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
    end

    context 'with invalid attributes' do
      let(:answer) { create(:answer) }

      it 'does not saves new question' do
        expect { post :create, params: { comment: attributes_for(:comment), answer_id: answer } }.to_not change(Comment, :count)
      end
    end
  end
end
