require 'rails_helper'

describe NotificationForQuestionSubscribersJob, type: :job do
  include ActiveJob::TestHelper

  let(:job) { NotificationForQuestionSubscribersJob.perform_now(answer) }

  let(:question) { create(:question) }
  let!(:subscriptions) { create_list(:subscription, 5, question: question) }
  let!(:answer) { create(:answer, question: question) }

  it 'enqueues mailer job' do
    expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(question.subscriptions.size)
  end

  it 'calls #new_answer_for_subscriber method of mailer' do
    question.subscriptions.each do |subscription|
      expect(AnswerNotificationMailer).to receive(:new_answer_for_subscriber).with(subscription.user, answer).and_call_original
    end

    job
  end
end
