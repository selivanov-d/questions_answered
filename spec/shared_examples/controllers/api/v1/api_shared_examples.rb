shared_examples_for 'API endpoint requiring authentication' do
  it 'returns 401 status code if there is no access_token' do
    process endpoint_name, method: http_method, params: { format: :json }.merge(params)
    expect(response.status).to eq 401
  end

  it 'returns 401 status code if access_token is invalid' do
    process endpoint_name, method: http_method, params: { access_token: '1234', format: :json }.merge(params)
    expect(response.status).to eq 401
  end
end

shared_examples_for 'API endpoint that received proper authentication credentials' do
  it 'returns 200 status' do
    expect(response.status).to eq 200
  end
end

shared_examples_for 'API endpoint responding with list of objects as JSON' do
  let(:collection_name) { collection[0].class.name.downcase.pluralize }

  it 'returns list of all collection objects' do
    expect(response.body).to have_json_size(collection.count).at_path(collection_name)
  end

  it 'each collection object contains proper list of attributes' do
    attributes_list.each do |attr|
      collection.each_with_index do |object, index|
        expect(response.body).to be_json_eql(object.send(attr.to_sym).to_json).at_path("#{collection_name}/#{index}/#{attr}")
      end
    end
  end
end

shared_examples_for 'API endpoint responding with requested object as JSON' do
  let(:object_name) { object.class.name.downcase }

  it 'contains proper list of attributes' do
    attributes_list.each do |attr|
      expect(response.body).to be_json_eql(object.send(attr.to_sym).to_json).at_path("#{object_name}/#{attr}")
    end
  end
end

shared_examples_for 'API endpoint responding with saved object as JSON' do
  let(:object_name) { object.class.name.downcase }

  it 'returns 201 status' do
    expect(response.status).to eq 201
  end

  it 'object contains list of attributes' do
    attributes_list.each do |attr|
      expect(response.body).to be_json_eql(object.send(attr.to_sym).to_json).at_path("#{object_name}/#{attr}")
    end
  end
end

shared_examples_for 'API endpoint responding with validation errors as JSON' do
  let(:object_name) { klass.name.downcase }

  it 'returns 422 status' do
    expect(response.status).to eq 422
  end

  it 'object contains list of non valid attributes' do
    attributes_list.each do |attr|
      expect(response.body).to have_json_path("errors/#{attr}")
    end
  end
end

shared_examples_for 'API endpoint responding with JSON of children models attached to parent' do
  let(:parent_node_name) { parent.class.name.downcase }
  let(:children_node_name) { children_klass.name.downcase.pluralize }

  it 'parent object contains list of all its children' do
    expect(response.body).to have_json_size(parent.send(children_node_name).count).at_path("#{parent_node_name}/#{children_node_name}")
  end

  it 'each attached child contains proper list of attributes' do
    children_attributes.each do |attr|
      parent.send(children_node_name).each_with_index do |child, index|
        expect(response.body).to be_json_eql(child.send(attr.to_sym).to_json).at_path("#{parent_node_name}/#{children_node_name}/#{index}/#{attr}")
      end
    end
  end
end
