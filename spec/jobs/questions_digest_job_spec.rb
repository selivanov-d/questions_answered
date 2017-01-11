require 'rails_helper'

describe QuestionsDigestJob, type: :job do
  include ActiveJob::TestHelper

  let!(:users) { create_list(:user, 2) }
  let(:job) { QuestionsDigestJob.perform_now }

  context 'when there are new questions' do
    let!(:questions) { create_list(:one_day_old_question, 5, user: users.first) }

    it 'enqueues mailer job ' do
      expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(users.size)
    end

    it 'calls #digest method of mailer' do
      users.each do |user|
        expect(QuestionsDailyDigestMailer).to receive(:digest).with(user, questions).and_call_original
      end

      job
    end
  end

  context 'when there are no new questions' do
    it 'does not enqueues mailer job' do
      expect { job }.to_not change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size)
    end

    it 'does not call #digest method of mailer' do
      expect(QuestionsDailyDigestMailer).to_not receive(:digest)

      job
    end
  end
end
