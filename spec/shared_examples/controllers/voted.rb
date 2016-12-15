require 'rails_helper'

shared_examples_for 'voted' do
  sign_in_user

  votable_klass_symbol = described_class.controller_name.singularize.to_sym
  let(:votable) { create(votable_klass_symbol) }

  describe 'POST #upvote' do
    before :each do |example|
      unless example.metadata[:skip_before]
        process :upvote, method: :post, params: { id: votable }, format: :js
      end
    end

    context 'not a votable\'s author' do
      context 'vote doesn\'t exists' do
        it 'assigns requested resource to @votable variable' do
          expect(assigns(:votable)).to eq(votable)
        end

        it 'saves new vote associated to votable', :skip_before do
          expect { process :upvote, method: :post, params: { id: votable }, format: :js }.to change(votable.votes, :count).by(1)
        end

        it 'saves new vote associated to user', :skip_before do
          expect { process :upvote, method: :post, params: { id: votable }, format: :js }.to change(@user.votes, :count).by(1)
        end

        it 'renders JSON-response with 200 HTTP-header' do
          success_json_response = {
            status: 'success',
            rating: 1
          }.to_json

          expect(response).to have_http_status(:ok)
          expect(response.body).to eq success_json_response
        end
      end

      context 'vote already exists' do
        before :each do |example|
          unless example.metadata[:skip_before]
            process :upvote, method: :post, params: { id: votable }, format: :js
          end
        end

        it 'assigns requested resource to @votable variable' do
          expect(assigns(:votable)).to eq(votable)
        end

        it 'doesn\'t saves vote' do
          expect { process :upvote, method: :post, params: { id: votable }, format: :js }.to_not change(Vote, :count)
        end

        it 'renders JSON-response with 200 HTTP-header' do
          success_json_response = {
            status: 'error',
            data: 'Проголосовать можно только один раз'
          }.to_json

          expect(response).to have_http_status(:ok)
          expect(response.body).to eq success_json_response
        end
      end
    end

    context 'votable\'s author' do
      let(:votable) { create(votable_klass_symbol, user: @user) }

      it 'doesn\'t saves new vote', :skip_before do
        expect { process :upvote, method: :post, params: { id: votable }, format: :js }.to_not change(Vote, :count)
      end

      it 'renders JSON-response with 422 HTTP-header', :skip_before do
        process :upvote, method: :post, params: { id: votable }, format: :js

        error_json_response = {
          status: 'error',
          data: 'Вы не можете голосовать за свой ресурс'
        }.to_json

        expect(response).to have_http_status(:forbidden)
        expect(response.body).to eq error_json_response
      end
    end
  end

  describe 'POST #downvote' do
    before :each do |example|
      unless example.metadata[:skip_before]
        process :downvote, method: :post, params: { id: votable }, format: :js
      end
    end

    context 'not a votable\'s author' do
      context 'vote doesn\'t exists' do
        it 'assigns requested resource to @votable variable' do
          expect(assigns(:votable)).to eq(votable)
        end

        it 'saves new vote associated to votable', :skip_before do
          expect { process :downvote, method: :post, params: { id: votable }, format: :js }.to change(votable.votes, :count).by(1)
        end

        it 'saves new vote associated to user', :skip_before do
          expect { process :downvote, method: :post, params: { id: votable }, format: :js }.to change(@user.votes, :count).by(1)
        end

        it 'renders JSON-response with 200 HTTP-header' do
          success_json_response = {
            status: 'success',
            rating: -1
          }.to_json

          expect(response).to have_http_status(:ok)
          expect(response.body).to eq success_json_response
        end
      end

      context 'vote already exists' do
        it 'assigns requested resource to @votable variable' do
          process :downvote, method: :post, params: { id: votable }, format: :js
          expect(assigns(:votable)).to eq(votable)
        end

        it 'doesn\'t saves vote' do
          expect { process :downvote, method: :post, params: { id: votable }, format: :js }.to_not change(Vote, :count)
        end

        it 'renders JSON-response with 200 HTTP-header' do
          process :downvote, method: :post, params: { id: votable }, format: :js

          success_json_response = {
            status: 'error',
            data: 'Проголосовать можно только один раз'
          }.to_json

          expect(response).to have_http_status(:ok)
          expect(response.body).to eq success_json_response
        end
      end
    end

    context 'votable\'s author' do
      let(:votable) { create(votable_klass_symbol, user: @user) }

      it 'doesn\'t saves new vote associated', :skip_before do
        expect { process :downvote, method: :post, params: { id: votable }, format: :js }.to_not change(Vote, :count)
      end

      it 'renders JSON-response with 422 HTTP-header' do
        error_json_response = {
          status: 'error',
          data: 'Вы не можете голосовать за свой ресурс'
        }.to_json

        expect(response).to have_http_status(:forbidden)
        expect(response.body).to eq error_json_response
      end
    end
  end

  describe 'DELETE #unvote' do
    context 'vote for votable made by user already exists' do
      before :each do
        create("positive_vote_for_#{votable_klass_symbol}", votable: votable, user: @user)
        process :unvote, method: :post, params: { id: votable }, format: :js
      end

      it 'assigns requested resource to @votable variable' do
        expect(assigns(:votable)).to eq(votable)
      end

       it 'removes all votes for votable made by user' do
        expect(votable.votes.count).to eq(0)
      end

      it 'renders JSON-response with 200 HTTP-header', :skip_before do
        success_json_response = {
          status: 'success',
          rating: 0
        }.to_json

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq success_json_response
      end
    end

    context 'vote for votable made by user doesn\'t exists' do
      before :each do |example|
        unless example.metadata[:skip_before]
          process :unvote, method: :post, params: { id: votable }, format: :js
        end
      end

      it 'assigns requested resource to @votable variable' do
        expect(assigns(:votable)).to eq(votable)
      end

      it 'doesn\'t removes any vote', :skip_before do
        expect { process :unvote, method: :post, params: { id: votable }, format: :js }.to_not change(Vote, :count)
      end

      it 'renders JSON-response with 200 HTTP-header' do
        error_json_response = {
          status: 'error',
          data: 'Вы ещё не дали своего голоса за этот ресурс'
        }.to_json

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq error_json_response
      end
    end
  end
end
