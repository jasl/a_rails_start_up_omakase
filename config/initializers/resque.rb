require 'resque/server'
require 'resque-cleaner'

Resque.before_first_fork = Proc.new { Rails.logger.auto_flushing = 1 }

module Resque::Plugins
  ResqueCleaner::Limiter.default_maximum = 10_000
end

class Authentication
  def initialize(app)
    @app = app
  end

  def call(env)
    account = env['warden'].authenticate!(:database_authenticatable, :rememberable, scope: :user)
    raise "Access denied" if !account.admin?
    @app.call(env)
  end
end

Resque::Server.use Authentication

# Resque::Mailer.excluded_environments = [:development, :test]
