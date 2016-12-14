require 'rails_helper'
require 'shared_examples/controllers/api/v1/api_shared_examples'

describe Api::V1::QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:access_token) { create(:access_token) }
    let(:http_method) { :get }
    let(:endpoint_name) { :index }

    let!(:questions) { create_list(:question, 5) }
    let(:params) { {} }

    context 'when unauthorized' do
      it_behaves_like 'API endpoint requiring authentication'
    end

    context 'when authorized' do
      before :each do
        process endpoint_name, method: http_method, params: { format: :json, access_token: access_token.token }.merge(params)
      end

      it_behaves_like 'API endpoint that received proper authentication credentials'
      it_behaves_like 'API endpoint responding with list of objects as JSON' do
        let(:collection) { questions }
        let(:attributes_list) { %w(id title content created_at updated_at) }
      end
    end
  end

  describe 'GET #show' do
    let(:access_token) { create(:access_token) }
    let(:http_method) { :get }
    let(:endpoint_name) { :show }

    let!(:question) { create(:question) }
    let!(:attachments) { create_list(:question_attachment, 2, attachable: question) }
    let!(:comments) { create_list(:comment, 5, commentable: question) }
    let(:params) { { id: question } }

    context 'when unauthorized' do
      it_behaves_like 'API endpoint requiring authentication'
    end

    context 'when authorized' do
      before :each do
        process endpoint_name, method: http_method, params: { format: :json, access_token: access_token.token }.merge(params)
      end

      it_behaves_like 'API endpoint that received proper authentication credentials'
      it_behaves_like 'API endpoint responding with requested object as JSON' do
        let(:object) { question }
        let(:attributes_list) { %w(id title content user_id created_at updated_at) }
      end
      it_behaves_like 'API endpoint responding with JSON of children models attached to parent' do
        let(:parent) { question }
        let(:children_klass) { Comment }
        let(:children_attributes) { %w(id content user_id created_at updated_at) }
      end

      context 'attachments' do
        it 'question object contains list of 2 attachments' do
          expect(response.body).to have_json_size(2).at_path('question/attachments')
        end

        it 'each attachment contains url to a file' do
          attachments_url = JSON.parse(response.body)['question']['attachments']
          expect(attachments_url.all? { |attachment| /test-file\.jpg$/.match(attachment) }).to eq true
        end
      end
    end
  end

  describe 'POST #create' do
    let(:access_token) { create(:access_token) }
    let(:http_method) { :post }
    let(:endpoint_name) { :create }

    let(:params) { { question: attributes_for(:question) } }

    context 'when unauthorized' do
      it_behaves_like 'API endpoint requiring authentication'

      it 'does not save new question' do
        expect { process :create, method: :post, params: { format: :json, access_token: '1234' }.merge(params) }.to_not change(Question, :count)
      end
    end

    context 'when authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      context 'with valid params' do
        before :each do |example|
          unless example.metadata[:skip_before]
            process endpoint_name, method: http_method, params: { question: attributes_for(:question), access_token: access_token.token, format: :json }
          end
        end

        it_behaves_like 'API endpoint responding with saved object as JSON' do
          let(:object) { Question.last }
          let(:attributes_list) { %w(id title content created_at updated_at) }
        end

        it 'saves new question attached to author', skip_before: true do
          expect { process endpoint_name, method: http_method, params: { question: attributes_for(:question), access_token: access_token.token, format: :json } }.to change(me.questions, :count).by(1)
        end
      end

      context 'with invalid params' do
        before :each do |example|
          unless example.metadata[:skip_before]
            process endpoint_name, method: http_method, params: { question: attributes_for(:invalid_question), access_token: access_token.token, format: :json }
          end
        end

        it_behaves_like 'API endpoint responding with validation errors as JSON' do
          let(:klass) { Question }
          let(:attributes_list) { %w(title content) }
        end

        it 'does not save new question', skip_before: true do
          expect { process endpoint_name, method: http_method, params: { question: attributes_for(:invalid_question), access_token: access_token.token, format: :json } }.to_not change(Question, :count)
        end
      end
    end
  end
end
