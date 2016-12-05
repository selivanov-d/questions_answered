require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get '/api/v1/questions', params: { access_token: '1234', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 5) }
      let!(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before :each do
        get '/api/v1/questions', params: { access_token: access_token.token, format: :json }
      end

      it 'returns 200 status' do
        expect(response.status).to eq 200
      end

      it 'returns list of 5 questions' do
        expect(response.body).to have_json_size(5).at_path('questions')
      end

      %w(id title content created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          questions.each_with_index do |question, index|
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/#{index}/#{attr}")
          end
        end
      end

      context 'answers' do
        it 'included in questions object' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id content created_at updated_at).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end
end
