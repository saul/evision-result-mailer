require 'mail'

Mail.defaults do
  delivery_method :smtp,       address: 'smtp.gmail.com',
                               port: 587,
                               domain: 'saulr.me',
                               user_name: ENV['GMAIL_EMAIL'],
                               password: ENV['GMAIL_PASSWORD'],
                               authentication: 'plain',
                               enable_starttls_auto: true
end
