Devise::Async.setup do |config|
  config.backend = :resque
  # config.mailer  = "Devise::Mailer"
  config.queue   = :mailer
end
