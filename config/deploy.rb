# Encoding: utf-8
require "capistrano_colors"
require "sushi/ssh"
require "bundler/capistrano"
require "rvm/capistrano"
load 'deploy/assets'

load 'config/recipes/su'

# load airbrake
# require './config/boot'
# require 'airbrake/capistrano'

settings = YAML.load_file("config/application.yml").fetch('production')

# Set remote server user
set :user, settings["deployment"]["deploy_user"]
set :use_sudo, false

# Fix RVM
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

default_run_options[:pty] = true

set :application, settings["deployment"]["app_name"]
set :repository, settings["deployment"]["repository"]
set :scm, :git
set :branch, settings["deployment"]["branch"]
ssh_options[:forward_agent] = true

set :deploy_to, "#{settings["deployment"]["path"]}/#{settings["deployment"]["app_name"]}"
set :copy_exclude, %w".git spec"

# RVM
set :rvm_ruby_string, settings["deployment"]["rvm_ruby"]
set :rvm_type, :system
# before 'deploy:setup', 'rvm:install_rvm'

# Whenever
require "whenever/capistrano"
# set :whenever_command, "#{settings["deployment"]["bundle_wrapper_cmd"] || "bundle"} exec whenever"

# Unicorn
require 'capistrano-unicorn'
set :unicorn_bin, 'unicorn_rails'
set :unicorn_bundle, settings["deployment"]["bundle_wrapper_cmd"]

# Delayed_job
require "delayed/recipes"
set :rails_env, "production"

server settings["deployment"]["server"], :app, :web, :db, :resque_worker, :resque_scheduler, :primary => true

depend :remote, :command, "bundle"
depend :remote, :command, settings["deployment"]["bundle_wrapper_cmd"]

namespace :deploy do
  namespace :assets do
    desc "Sync compiled assets to cdn"
    task :sync_to_cdn, :roles => :web do
      run "cd #{latest_release}; bundle exec rake assets:sync_to_cdn RAILS_ENV=production"
    end
  end
end

# after "deploy:assets:precompile", 'deploy:assets:sync_to_cdn'

namespace :db do
  desc "Migrate database"
  task :migrate do
    run "cd #{latest_release}; bundle exec rake db:migrate RAILS_ENV=production"
  end

  desc "Import seeds"
  task :seed do
    run "cd #{latest_release}; bundle exec rake db:seed RAILS_ENV=production"
  end
end

after "deploy:finalize_update", "db:migrate"
after 'deploy:start', 'unicorn:start'
after 'deploy:stop', 'unicorn:stop'
after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"
