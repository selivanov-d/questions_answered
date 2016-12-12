require 'rails_helper'
require 'shared_examples/controllers/api/v1/api_authenticated'

describe Api::V1::QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:controller_method) { :index }
    let(:http_method) { :get }
    let(:access_token) { create(:access_token) }
    let!(:collection) { create_list(:question, 5) }
    let(:attributes_list) { %w(id title content created_at updated_at) }
    let(:params) { {} }

    context 'when unauthorized' do
      it_behaves_like 'API method requiring authentication'
    end

    context 'when authorized' do
      before :each do
        process controller_method, method: http_method, params: { format: :json, access_token: access_token.token }.merge(params)
      end

      it_behaves_like 'API method returning JSON'
      it_behaves_like 'API method returning list of objects as JSON'
    end
  end

  describe 'GET #show' do
    let(:controller_method) { :show }
    let(:http_method) { :get }
    let(:access_token) { create(:access_token) }
    let!(:object) { create(:question) }
    let(:attributes_list) { %w(id title content user_id created_at updated_at) }
    let(:params) { { id: object } }

    context 'when unauthorized' do
      it_behaves_like 'API method requiring authentication'
    end

    context 'when authorized' do
      before :each do
        process controller_method, method: http_method, params: { format: :json, access_token: access_token.token }.merge(params)
      end

      it_behaves_like 'API method returning JSON'
      it_behaves_like 'API method returning single object as JSON'
    end
  end

  describe 'POST #create' do
    let(:controller_method) { :create }
    let(:http_method) { :post }
    let(:access_token) { create(:access_token) }
    let(:attributes_list) { %w(id title content user_id created_at updated_at) }
    let(:params) { { question: attributes_for(:question) } }

    context 'when unauthorized' do
      it_behaves_like 'API method requiring authentication'

      it 'does not save new question' do
        expect { process :create, method: :post, params: { format: :json, access_token: '1234' }.merge(params) }.to_not change(Question, :count)
      end
    end

    context 'when authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:success_attributes_list) { %w(id title content created_at updated_at) }
      let(:error_attributes_list) { %w(title content) }

      context 'with valid params' do
        before :each do |example|
          unless example.metadata[:skip_before]
            process :create, method: :post, params: { question: attributes_for(:question), access_token: access_token.token, format: :json }
          end
        end

        it_behaves_like 'API method saving object', Question

        it 'saves new question', skip_before: true do
          expect { process :create, method: :post, params: { question: attributes_for(:question), access_token: access_token.token, format: :json } }.to change(me.questions, :count).by(1)
        end
      end

      context 'with invalid params' do
        before :each do |example|
          unless example.metadata[:skip_before]
            post :create, params: { question: attributes_for(:invalid_question), access_token: access_token.token, format: :json }
          end
        end

        it_behaves_like 'API method not saving object', Question

        it 'does not save new question', skip_before: true do
          expect { post :create, params: { question: attributes_for(:invalid_question), access_token: access_token.token, format: :json } }.to_not change(Question, :count)
        end
      end
    end
  end
end
