# Encoding: utf-8
require 'capistrano_colors'
require 'sushi/ssh'
require 'bundler/capistrano'
load 'deploy/assets'
# load 'config/recipes/su'

env = ENV['STAGE'] || 'production'

settings = YAML.load_file('config/application.yml').fetch(env)

set :rails_env, env

# Set remote server user
set :user, settings['deployment']['deploy_user']
set :use_sudo, false

default_run_options[:pty] = true

set :application, settings['deployment']['app_name']
set :repository, settings['deployment']['repository']
set :branch, settings['deployment']['branch']
set :scm, :git
ssh_options[:forward_agent] = true

set :deploy_to, "#{settings['deployment']['path']}/#{settings['deployment']['app_name']}"
set :copy_exclude, %w".git spec"

# RVM
set :rvm_ruby_string, settings['deployment']['rvm_ruby']
set :rvm_type, :system
require 'rvm/capistrano'
# before 'deploy', 'rvm:install_rvm'
# before 'deploy', 'rvm:install_ruby'

# Unicorn
require 'capistrano-unicorn'
set :unicorn_bin, 'unicorn_rails'
# set :unicorn_bundle, settings['deployment']['bundle_wrapper_cmd']

# Delayed_job
require 'delayed/recipes'
set :rails_stage, rails_env

load 'config/recipes/db'

after 'deploy:finalize_update', 'db:migrate'
after 'deploy:start', 'unicorn:start'
after 'deploy:stop', 'unicorn:stop'
after 'deploy:restart', 'unicorn:restart'
after 'deploy:stop', 'delayed_job:stop'
after 'deploy:start', 'delayed_job:start'
after 'deploy:restart', 'delayed_job:restart'

eval File.read "config/deploy/#{env}.rb"
