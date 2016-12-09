require 'rails_helper'

describe Api::V1::AnswersController, type: :controller do
  describe 'GET #index' do
    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 5, question: question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get :index, params: { question_id: question, format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get :index, params: { question_id: question, access_token: '1234', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answer) { answers.first }

      before :each do
        get :index, params: { question_id: question, access_token: access_token.token, format: :json }
      end

      it 'returns 200 status' do
        expect(response.status).to eq 200
      end

      it 'returns list of 5 answers' do
        expect(response.body).to have_json_size(5).at_path('answers')
      end

      %w(id content question_id user_id best created_at updated_at).each do |attr|
        it "each answer object contains #{attr} attribute" do
          answers.each_with_index do |answer, index|
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/#{index}/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET #show' do
    context 'unauthorized' do
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }

      it 'returns 401 status if there is no access token' do
        get :show, params: { id: answer, format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get :show, params: { id: answer, access_token: '1234', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }
      let!(:comments) { create_list(:comment, 5, commentable: answer) }
      let!(:attachments) { create_list(:answer_attachment, 5, attachable: answer) }

      before :each do
        get :show, params: { id: answer, access_token: access_token.token, format: :json }
      end

      it 'returns 200 status' do
        expect(response.status).to eq 200
      end

      %w(id content created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'answer object contains list of 5 comments' do
          expect(response.body).to have_json_size(5).at_path('answer/comments')
        end

        %w(id content user_id created_at updated_at).each do |attr|
          it "each comment contains #{attr} attribute" do
            answer.comments.each_with_index do |comment, index|
              expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/#{index}/#{attr}")
            end
          end
        end
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

  # describe 'GET #create' do
  #   context 'unauthorized' do
  #     it 'does not save new question' do
  #       expect { post :create, params: { question: attributes_for(:question), access_token: '1234', format: :json } }.to_not change(Question, :count)
  #     end
  #
  #     it 'returns 401 status if there is no access token' do
  #       get :create, params: { question: attributes_for(:question), format: :json }
  #       expect(response.status).to eq 401
  #     end
  #
  #     it 'returns 401 status if access token is invalid' do
  #       get :create, params: { question: attributes_for(:question), access_token: '1234', format: :json }
  #       expect(response.status).to eq 401
  #     end
  #   end
  #
  #   context 'authorized' do
  #     let(:me) { create(:user) }
  #     let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  #
  #     context 'with valid params' do
  #       before :each do
  #         post :create, params: { question: attributes_for(:question), access_token: access_token.token, format: :json }
  #       end
  #
  #       it 'saves new question' do
  #         expect { post :create, params: { question: attributes_for(:question), access_token: access_token.token, format: :json } }.to change(me.questions, :count).by(1)
  #       end
  #
  #       it 'returns 201 status' do
  #         expect(response.status).to eq 201
  #       end
  #
  #       %w(id title content created_at updated_at).each do |attr|
  #         it "returned JSON of created question object contains #{attr}" do
  #           question = Question.last
  #           expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
  #         end
  #       end
  #     end
  #
  #     context 'with invalid params' do
  #       before :each do
  #         post :create, params: { question: attributes_for(:invalid_question), access_token: access_token.token, format: :json }
  #       end
  #
  #       it 'does not save new question' do
  #         expect { post :create, params: { question: attributes_for(:invalid_question), access_token: access_token.token, format: :json } }.to_not change(Question, :count)
  #       end
  #
  #       it 'returns 422 status' do
  #         expect(response.status).to eq 422
  #       end
  #
  #       %w(title content).each do |attr|
  #         it "returned JSON of with validation message for #{attr}" do
  #           expect(response.body).to have_json_path("errors/#{attr}")
  #         end
  #       end
  #     end
  #   end
  # end
end
