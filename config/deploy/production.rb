server settings['deployment']['server'], :app, :web, :db, :primary => true

# load airbrake
# require './config/boot'
# require 'airbrake/capistrano'

if settings['upyun']['assets']
  load 'config/recipes/upyun'
  after 'deploy:assets:precompile', 'deploy:assets:sync_to_upyun'
end
