require 'rails_helper'

RSpec.shared_examples 'commentable' do
  it { should have_many(:comments).dependent(:destroy) }
end
