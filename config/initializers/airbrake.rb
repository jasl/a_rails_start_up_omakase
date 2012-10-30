unless Setting.tokens.airbrake.blank?
  Airbrake.configure do |config|
    config.api_key = Setting.tokens.airbrake
  end
end
