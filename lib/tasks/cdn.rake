namespace :assets do
  desc 'sync assets to cdns'
  task :sync_to_cdn => :environment do
    ftp = FtpSync.new("v0.ftp.upyun.com", [Setting.upyun.username, Setting.upyun.assets.bucket].join("/"), Setting.upyun.password,true)
    ftp.sync("#{Rails.root}/public/assets/", "/assets")
  end
end
