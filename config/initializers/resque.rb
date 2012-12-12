require 'resque/server'
require 'resque-cleaner'

# not support yet
# Resque.logger = Logger.new("#{Rails.root}/log/resque_#{Rails.env}.log")

module Resque::Plugins
  ResqueCleaner::Limiter.default_maximum = 10_000
end

# Resque::Mailer.excluded_environments = [:development, :test]
