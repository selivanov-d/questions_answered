every 1.day, :at => '0:00 am' do
  runner 'QuestionsDigestJob.perform'
end

every 60.minutes do
  rake 'ts:index'
end
