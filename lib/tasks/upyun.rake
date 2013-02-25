namespace :assets do
  desc 'sync assets to upyun'
  task :sync_to_upyun => :environment do
    ftp = FtpSync.new('v0.ftp.upyun.com', [Setting.upyun.username, Setting.upyun.assets.bucket].join("/"), Setting.upyun.password,true)
    ftp.sync("#{Rails.root}/public/assets/", '/assets')
  end
end
