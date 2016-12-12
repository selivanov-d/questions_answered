require 'rails_helper'
require 'shared_examples/controllers/api/v1/api_authenticated'

describe Api::V1::ProfilesController, type: :controller do
  describe 'GET /me' do
    let(:object) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: object.id) }
    let(:attributes_list) { %w(id email created_at updated_at admin) }
    let(:http_method) { :get }
    let(:controller_method) { :me }
    let(:params) { {} }

    context 'when unauthorized' do
      it_behaves_like 'API method requiring authentication'
    end

    context 'when authorized' do
      before :each do
        process controller_method, method: http_method, params: { format: :json, access_token: access_token.token }.merge(params)
      end

      it_behaves_like 'API method returning JSON'
      it_behaves_like 'API method returning single object as JSON'

      it 'does not contains list of sensitive attributes' do
        %w(password encrypted_password).each do |attr|
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /list' do
    let!(:collection) { create_list(:user, 5) }
    let!(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let(:attributes_list) { %w(id email created_at updated_at admin) }
    let(:http_method) { :get }
    let(:controller_method) { :list }
    let(:params) { {} }

    context 'when unauthorized' do
      it_behaves_like 'API method requiring authentication'
    end

    context 'when authorized' do
      before :each do
        process :list, method: :get, params: { access_token: access_token.token, format: :json }
      end

      it_behaves_like 'API method returning JSON'
      it_behaves_like 'API method returning list of objects as JSON'

      it 'returned list contains every user except current user' do
        expect(response.body).to be_json_eql(collection.to_json).at_path('users')
        expect(response.body).to_not include_json(me.to_json).at_path('users')
      end

      it 'each user does not contains list of sensitive attributes' do
        %w(password encrypted_password).each do |attr|
          collection.each_index do |index|
            expect(response.body).to_not have_json_path("users/#{index}/#{attr}")
          end
        end
      end
    end
  end
end
