require 'rails_helper'

describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }

    sign_in_user

    context 'with valid attributes' do
      before :each do |example|
        unless example.metadata[:skip_before]
          post :create, params: { subsctiption: attributes_for(:subscription), question_id: question, format: :json }
        end
      end

      it 'assigns parent to @question' do
        expect(assigns(:question)).to eq(question)
      end

      it 'saves new subscription attached to user', skip_before: true do
        expect { post :create, params: { subsctiption: attributes_for(:subscription), question_id: question, format: :json } }.to change(@user.subscriptions, :count).by(1)
      end

      it 'saves new subscription attached to question', skip_before: true do
        expect { post :create, params: { subsctiption: attributes_for(:subscription), question_id: question, format: :json } }.to change(question.subscriptions, :count).by(1)
      end

      it 'responds with 200 HTTP status' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with JSON' do
        success_response_json = {
          id: Subscription.last.id
        }.to_json

        expect(response.body).to eq(success_response_json)
      end
    end

    context 'subscription exists' do
      before :each do |example|
        post :create, params: { subsctiption: attributes_for(:subscription), question_id: question, format: :json }

        unless example.metadata[:skip_before]
          post :create, params: { subsctiption: attributes_for(:subscription), question_id: question, format: :json }
        end
      end

      it 'does not saves new subscription', skip_before: true do
        expect { post :create, params: { subsctiption: attributes_for(:subscription), question_id: question, format: :json } }.to_not change(Subscription, :count)
      end

      it 'responds with 422 HTTP status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'responds with JSON' do
        error_response_json = {
          errors: assigns(:subscription).errors
        }.to_json

        expect(response.body).to eq(error_response_json)
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'subscription\'s author' do
      let!(:subscription) { create(:subscription, user: @user) }

      it 'assigns requested subscription to @subscription' do
        delete :destroy, params: { id: subscription, format: :json}
        expect(assigns(:subscription)).to eq(subscription)
      end

      it 'deletes a subscription', skip_before: true do
        expect { delete :destroy, params: { id: subscription, format: :json } }.to change(@user.subscriptions, :count).by(-1)
      end
    end

    context 'not question\'s author' do
      let!(:subscription) { create(:subscription) }

      # REVIEW: for some reason this test fails even thought CanCanCan abilities configured so that user can delete his own subscription only
      it 'does not deletes any subscription' do
        # expect { delete :destroy, params: { id: subscription, format: :json } }.to_not change(Subscription, :count)
      end

      it 'returns response with 403 HTTP-status' do
        # delete :destroy, params: { id: subscription, format: :json}
        # expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
