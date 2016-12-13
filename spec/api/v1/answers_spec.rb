require 'rails_helper'
require 'shared_examples/controllers/api/v1/api_authenticated'

describe Api::V1::AnswersController, type: :controller do
  describe 'GET #index' do
    let(:question) { create(:question) }
    let!(:collection) { create_list(:answer, 5, question: question) }
    let!(:answer) { collection.first }
    let(:controller_method) { :index }
    let(:http_method) { :get }
    let(:attributes_list) { %w(id content question_id user_id best created_at updated_at) }
    let(:access_token) { create(:access_token) }
    let(:params) { { question_id: question } }

    context 'when unauthorized' do
      it_behaves_like 'API method requiring authentication'
    end

    context 'when authorized' do
      before :each do
        process :index, method: http_method, params: { question_id: question, access_token: access_token.token, format: :json }
      end

      it_behaves_like 'API method returning JSON'
      it_behaves_like 'API method returning list of objects as JSON'
    end
  end

  describe 'GET #show' do
    let(:access_token) { create(:access_token) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let(:controller_method) { :show }
    let(:http_method) { :get }
    let!(:comments) { create_list(:comment, 5, commentable: answer) }
    let!(:attachments) { create_list(:answer_attachment, 5, attachable: answer) }
    let(:attributes_list) { %w(id content created_at updated_at) }
    let(:params) { { id: answer } }

    context 'when unauthorized' do
      it_behaves_like 'API method requiring authentication'
    end

    context 'when authorized' do
      before :each do
        process :show, method: http_method, params: { id: answer, access_token: access_token.token, format: :json }
      end

      it_behaves_like 'API method returning JSON'
      it_behaves_like 'API method returning single object as JSON', Answer
      it_behaves_like 'API method returning attached models' do
        let(:parent) { answer }
        let(:children) { comments }
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
    let!(:question) { create(:question) }
    let(:http_method) { :post }
    let(:controller_method) { :create }
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let(:success_attributes_list) { %w(id content best user_id question_id created_at updated_at) }
    let(:error_attributes_list) { %w(content) }
    let(:params) { { question_id: question } }

    context 'when unauthorized' do
      it_behaves_like 'API method requiring authentication'

      it 'does not save new answer' do
        expect { process :create, method: http_method, params: {
          question_id: question,
          answer: attributes_for(:answer),
          access_token: '1234',
          format: :json }
        }.to_not change(Answer, :count)
      end
    end

    context 'when authorized' do
      context 'with valid params' do
        before :each do |example|
          unless example.metadata[:skip_before]
            process :create, method: http_method, params: { question_id: question, answer: attributes_for(:answer), user_id: me, access_token: access_token.token, format: :json }
          end
        end

        it_behaves_like 'API method saving object', Answer

        it 'saves new answer linked to author', skip_before: true do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer), access_token: access_token.token, format: :json } }.to change(me.answers, :count).by(1)
        end

        it 'saves new answer linked to answer', skip_before: true do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer), access_token: access_token.token, format: :json } }.to change(question.answers, :count).by(1)
        end
      end

      context 'with invalid params' do
        before :each do |example|
          unless example.metadata[:skip_before]
            post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), access_token: access_token.token, format: :json }
          end
        end

        it_behaves_like 'API method not saving object', Answer

        it 'does not save new answer', skip_before: true do
          expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), access_token: access_token.token, format: :json } }.to_not change(Answer, :count)
        end
      end
    end
  end
end
