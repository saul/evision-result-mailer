set :output, 'log/cron.log'

every 15.minutes do
  rake 'mail_diff'
end
