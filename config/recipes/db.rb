namespace :db do
  desc 'Migrate database'
  task :migrate do
    run "cd #{latest_release}; bundle exec rake db:migrate RAILS_ENV=#{rails_env}"
  end

  desc 'Import seeds'
  task :seed do
    run "cd #{latest_release}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end
end
