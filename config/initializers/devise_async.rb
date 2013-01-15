Devise::Async.setup do |config|
  config.backend = :delayed_job
  # config.mailer  = "Devise::Mailer"
  config.queue   = :mailer
end
