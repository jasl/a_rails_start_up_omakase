ASSET_FORMAT = '*.{coffee,scss,sass,png,jpeg,jpg,gif,js,css,erb}'
NEED_TO_COMPILE_STYLESHEET_EXT = %w(.scss .sass .coffee .erb)

def precompile_assets
  assets = []

  %w(app vendor).each do |source|
    %w(images javascripts stylesheets).each do |kind|
      Dir[Rails.root.join("#{source}/assets/#{kind}/**", ASSET_FORMAT)].each do |path|
        next if File.basename(path)[0] == '_'

        ext = File.extname(path)
        path = path[0..-ext.length-1] if NEED_TO_COMPILE_STYLESHEET_EXT.include? ext

        assets << Pathname.new(path).relative_path_from(Rails.root.join("#{source}/assets/#{kind}"))
      end
    end
  end

  assets
end

StartUp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  config.assets.js_compressor  = :uglifier
  config.assets.css_compressor = :scss

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)
  config.logger = Logger.new("#{Rails.root}/log/#{Rails.env}.log", 'weekly')

  # Use a different cache store in production
  config.cache_store = [:dalli_store,"127.0.0.1", {:namespace => "start_up", :compress => true}]

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  unless Setting.upyun.assets.bucket_domain.blank?
    config.action_controller.asset_host = Setting.upyun.assets.bucket_domain
  end

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  #config.assets.precompile = [
  #     method(:compile_asset?).to_proc,
  #     /(?:\/|\\|\A)application\.(css|js)$/
  # ]

  config.assets.precompile = precompile_assets

  # config.assets.precompile += %w"rails_admin/rails_admin.css rails_admin/rails_admin.js"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = false

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  config.action_mailer.delivery_method = :sendmail
  # Defaults to:
  # # config.action_mailer.sendmail_settings = {
  # #   :location => '/usr/sbin/sendmail',
  # #   :arguments => '-i -t'
  # # }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
end
