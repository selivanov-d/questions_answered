require 'rails_helper'

describe NewAnswerNotificationJob, type: :job do
  include ActiveJob::TestHelper

  let(:job) { NewAnswerNotificationJob.perform_now(answer) }
  let(:question) { create(:question) }
  let!(:subscriptions) { create_list(:subscription, 5, question: question) }
  let!(:answer) { create(:answer, question: question) }

  it 'enqueues mailer job' do
    expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(6)
  end

  it 'performs job for a subscriber of the answer and for the author of the answer' do
    answer.question.subscriptions.each do |subscription|
      expect(NewAnswerNotificationMailer).to receive(:notify).with(subscription.user, answer).and_call_original
    end

    expect(NewAnswerNotificationMailer).to receive(:notify).with(question.user, answer).and_call_original

    job
  end
end
