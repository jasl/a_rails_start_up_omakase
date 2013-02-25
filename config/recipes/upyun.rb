namespace :deploy do
  namespace :assets do
    desc 'Sync compiled assets to upyun'
    task :sync_to_upyun, :roles => :web do
      run "cd #{latest_release}; bundle exec rake assets:sync_to_upyun RAILS_ENV=#{rails_env}"
    end
  end
end
