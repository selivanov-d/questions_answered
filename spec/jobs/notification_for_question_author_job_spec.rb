require 'rails_helper'

describe NotificationForQuestionAuthorJob, type: :job do
  include ActiveJob::TestHelper

  let(:job) { NotificationForQuestionAuthorJob.perform_now(answer) }

  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  it 'enqueues mailer job' do
    expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'calls #new_answer method of mailer' do
    expect(AnswerNotificationMailer).to receive(:new_answer).with(answer).and_call_original

    job
  end
end
