require 'rails_helper'
require 'shared_examples/controllers/api/v1/api_shared_examples'

describe Api::V1::ProfilesController, type: :controller do
  describe 'GET /me' do
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:endpoint_name) { :me }
    let(:http_method) { :get }

    let(:user) { create(:user) }
    let(:params) { {} }

    context 'when unauthorized' do
      it_behaves_like 'receiving invalid auth credentials'
    end

    context 'when authorized' do
      before :each do
        process endpoint_name, method: http_method, params: { format: :json, access_token: access_token.token }.merge(params)
      end

      it_behaves_like 'receiving valid auth credentials'
      it_behaves_like 'responding with requested object' do
        let(:object) { user }
        let(:attributes_list) { %w(id email created_at updated_at admin) }
      end

      it 'does not contains list of sensitive attributes' do
        %w(password encrypted_password).each do |attr|
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /list' do
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let(:endpoint_name) { :list }
    let(:http_method) { :get }

    let!(:me) { create(:user) }
    let!(:users) { create_list(:user, 5) }
    let(:params) { {} }

    context 'when unauthorized' do
      it_behaves_like 'receiving invalid auth credentials'
    end

    context 'when authorized' do
      before :each do
        process endpoint_name, method: http_method, params: { access_token: access_token.token, format: :json }
      end

      it_behaves_like 'receiving valid auth credentials'
      it_behaves_like 'responding with list of objects' do
        let(:collection) { users }
        let(:attributes_list) { %w(id email created_at updated_at admin) }
      end

      it 'returned list contains every user except current user' do
        expect(response.body).to be_json_eql(users.to_json).at_path('users')
        expect(response.body).to_not include_json(me.to_json).at_path('users')
      end

      it 'each user does not contain list of sensitive attributes' do
        %w(password encrypted_password).each do |attr|
          users.each_index do |index|
            expect(response.body).to_not have_json_path("users/#{index}/#{attr}")
          end
        end
      end
    end
  end
end
