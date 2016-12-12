shared_examples_for 'API method requiring authentication' do
  it 'returns 401 status code if there is no access_token' do
    process controller_method, method: http_method, params: { format: :json }.merge(params)
    expect(response.status).to eq 401
  end

  it 'returns 401 status code if access_token is invalid' do
    process controller_method, method: http_method, params: { access_token: '1234', format: :json }.merge(params)
    expect(response.status).to eq 401
  end
end

shared_examples_for 'API method returning JSON' do
  it 'returns 200 status' do
    expect(response.status).to eq 200
  end
end

shared_examples_for 'API method returning list of objects as JSON' do
  let(:collection_name) { collection[0].class.name.downcase.pluralize }

  it 'returns list of 5 objects' do
    expect(response.body).to have_json_size(5).at_path(collection_name)
  end

  it 'each object contains list of attributes' do
    attributes_list.each do |attr|
      collection.each_with_index do |object, index|
        expect(response.body).to be_json_eql(object.send(attr.to_sym).to_json).at_path("#{collection_name}/#{index}/#{attr}")
      end
    end
  end
end

shared_examples_for 'API method returning single object as JSON' do
  let(:object_name) { object.class.name.downcase }

  it 'each object contains list of attributes' do
    attributes_list.each do |attr|
      expect(response.body).to be_json_eql(object.send(attr.to_sym).to_json).at_path("#{object_name}/#{attr}")
    end
  end
end

shared_examples_for 'API method saving object' do |klass|
  let(:object) { klass.last }
  let(:object_name) { klass.name.downcase }

  it 'returns 201 status' do
    expect(response.status).to eq 201
  end

  it 'object contains list of attributes' do
    success_attributes_list.each do |attr|
      expect(response.body).to be_json_eql(object.send(attr.to_sym).to_json).at_path("#{object_name}/#{attr}")
    end
  end
end

shared_examples_for 'API method not saving object' do |klass|
  let(:object) { klass.last }
  let(:object_name) { klass.name.downcase }

  it 'returns 422 status' do
    expect(response.status).to eq 422
  end

  it 'object contains list of non valid attributes' do
    error_attributes_list.each do |attr|
      expect(response.body).to have_json_path("errors/#{attr}")
    end
  end
end
