require 'rails_helper'

describe 'Profile API' do

  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get '/api/v1/profiles/me', params: { access_token: '1234', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before :each do
        get '/api/v1/profiles/me', params: { access_token: access_token.token, format: :json }
      end

      it 'returns 200 status' do
        expect(response.status).to eq 200
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end
end
