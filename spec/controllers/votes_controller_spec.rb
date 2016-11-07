require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  describe 'POST #create' do
    sign_in_user

    let!(:question) { create(:question, user: @user) }

    context 'question' do
      before :each do
        process :create, method: :post, params: { votable: question, user_id: @user }
      end

      it 'saves a vote', :skip_before do
        expect { process :create, method: :post, params: { votable: question, user_id: @user }, format: :js }.to change(question.votes, :count).by(1)
      end

      it 'renders JSON-response with 200 HTTP-header' do
        success_json_response = {
          status: 'success',
          rating: 1
        }.to_json

        expect(response).to have_http_status(:ok)
        expect(response.body).to success_json_response
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let!(:question) { create(:question, user: @user) }
    let!(:vote) { create(:positive_vote_for_answer, votable: question, user: @user) }

    context 'question' do
      before :each do |example|
        unless example.metadata[:skip_before]
          process :destroy, method: :delete, params: { id: vote }
        end
      end

      it 'deletes a question', :skip_before do
        expect { process :destroy, method: :delete, params: { id: vote }, format: :js }.to change(question.votes, :count).by(-1)
      end

      it 'renders JSON-response with 200 HTTP-header' do
        success_json_response = {
          status: 'success',
          rating: 0
        }.to_json

        expect(response).to have_http_status(:ok)
        expect(response.body).to success_json_response
      end
    end
  end
end
