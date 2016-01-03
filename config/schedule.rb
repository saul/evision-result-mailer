env :PATH, ENV['PATH']
env :GEM_PATH, ENV['GEM_PATH']

set :output, 'log/cron.log'

every 15.minutes do
  rake 'mail_diff'
end
