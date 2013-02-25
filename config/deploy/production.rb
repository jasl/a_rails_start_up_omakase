settings = YAML.load_file('config/application.yml').fetch('production')
set :rails_env, 'production'

set :user, settings['deployment']['deploy_user']
set :application, settings['deployment']['app_name']
set :repository, settings['deployment']['repository']
set :branch, settings['deployment']['branch']
set :deploy_to, "#{settings['deployment']['path']}/#{settings['deployment']['app_name']}"
set :rvm_ruby_string, settings['deployment']['rvm_ruby']

server settings['deployment']['server'], :app, :web, :db, :primary => true

if settings['upyun']['assets']
  load 'config/recipes/upyun'
  after 'deploy:assets:precompile', 'deploy:assets:sync_to_upyun'
end
