FactoryGirl.define do
  factory :question_attachment, class: 'Attachment' do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'files', 'test-file.jpg')) }
    association :attachable, factory: :question
  end

  factory :answer_attachment, class: 'Attachment' do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'files', 'test-file.jpg')) }
    association :attachable, factory: :answer
  end
end
