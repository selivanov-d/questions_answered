require 'rails_helper'
require 'shared_examples/controllers/api/v1/api_shared_examples'

describe Api::V1::AnswersController, type: :controller do
  describe 'GET #index' do
    let(:access_token) { create(:access_token) }
    let(:http_method) { :get }
    let(:endpoint_name) { :index }

    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 5, question: question) }
    let(:params) { { question_id: question } }

    context 'when unauthorized' do
      it_behaves_like 'receiving invalid auth credentials'
    end

    context 'when authorized' do
      before :each do
        process endpoint_name, method: http_method, params: { question_id: question, access_token: access_token.token, format: :json }
      end

      it_behaves_like 'receiving valid auth credentials'
      it_behaves_like 'responding with list of objects' do
        let!(:collection) { answers }
        let(:attributes_list) { %w(id content question_id user_id best created_at updated_at) }
      end
    end
  end

  describe 'GET #show' do
    let(:access_token) { create(:access_token) }
    let(:http_method) { :get }
    let(:endpoint_name) { :show }

    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:comments) { create_list(:comment, 5, commentable: answer) }
    let!(:attachments) { create_list(:answer_attachment, 5, attachable: answer) }
    let(:params) { { id: answer } }

    context 'when unauthorized' do
      it_behaves_like 'receiving invalid auth credentials'
    end

    context 'when authorized' do
      before :each do
        process endpoint_name, method: http_method, params: { id: answer, access_token: access_token.token, format: :json }
      end

      it_behaves_like 'receiving valid auth credentials'
      it_behaves_like 'responding with requested object' do
        let(:object) { answer }
        let(:attributes_list) { %w(id content created_at updated_at) }
      end
      it_behaves_like 'responding with children' do
        let(:parent) { answer }
        let(:children_klass) { Comment }
        let(:children_attributes) { %w(id content user_id created_at updated_at) }
      end

      context 'attachments' do
        it 'answer object contains list of 5 attachments' do
          expect(response.body).to have_json_size(5).at_path('answer/attachments')
        end

        it 'each attachment contains url to a file' do
          attachments_url = JSON.parse(response.body)['answer']['attachments']
          expect(attachments_url.all? { |attachment| /test-file\.jpg$/.match(attachment) }).to eq true
        end
      end
    end
  end

  describe 'POST #create' do
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let(:http_method) { :post }
    let(:endpoint_name) { :create }

    let!(:question) { create(:question) }
    let(:me) { create(:user) }
    let(:params) { { question_id: question } }

    context 'when unauthorized' do
      it_behaves_like 'receiving invalid auth credentials'

      it 'does not save new answer' do
        expect { process endpoint_name, method: http_method, params: { question_id: question, answer: attributes_for(:answer), access_token: '1234', format: :json } }.to_not change(Answer, :count)
      end
    end

    context 'when authorized' do
      context 'with valid params' do
        before :each do |example|
          unless example.metadata[:skip_before]
            process endpoint_name, method: http_method, params: { question_id: question, answer: attributes_for(:answer), user_id: me, access_token: access_token.token, format: :json }
          end
        end

        it_behaves_like 'responding with saved object' do
          let(:object) { Answer.last }
          let(:attributes_list) { %w(id content best user_id question_id created_at updated_at) }
        end

        it 'saves new answer linked to author', skip_before: true do
          expect { process endpoint_name, method: http_method, params: { question_id: question, answer: attributes_for(:answer), access_token: access_token.token, format: :json } }.to change(me.answers, :count).by(1)
        end

        it 'saves new answer linked to answer', skip_before: true do
          expect { process endpoint_name, method: http_method, params: { question_id: question, answer: attributes_for(:answer), access_token: access_token.token, format: :json } }.to change(question.answers, :count).by(1)
        end
      end

      context 'with invalid params' do
        before :each do |example|
          unless example.metadata[:skip_before]
            post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), access_token: access_token.token, format: :json }
          end
        end

        it_behaves_like 'responding with validation errors' do
          let(:klass) { Answer }
          let(:attributes_list) { %w(content) }
        end

        it 'does not save new answer', skip_before: true do
          expect { process endpoint_name, method: http_method, params: { question_id: question, answer: attributes_for(:invalid_answer), access_token: access_token.token, format: :json } }.to_not change(Answer, :count)
        end
      end
    end
  end
end
