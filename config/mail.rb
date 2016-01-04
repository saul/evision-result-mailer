require 'mail'

Mail.defaults do
  delivery_method :smtp,       address: 'smtp.gmail.com',
                               port: 587,
                               domain: 'evision-results-mailer.local',
                               user_name: ENV.fetch('GMAIL_EMAIL'),
                               password: ENV.fetch('GMAIL_PASSWORD'),
                               authentication: 'plain',
                               enable_starttls_auto: true
end
