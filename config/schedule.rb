every 1.day, :at => '0:00 am' do
  runner 'QuestionsDigestJob.perform'
end
