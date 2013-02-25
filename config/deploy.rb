# Encoding: utf-8
require 'capistrano_colors'
require 'sushi/ssh'
require 'bundler/capistrano'
require 'rvm/capistrano'
load 'deploy/assets'

env = ENV['STAGE'] || 'production'
load "config/deploy/#{env}.rb"
# load 'config/recipes/su'

# load airbrake
# require './config/boot'
# require 'airbrake/capistrano'

# Set remote server user
# set :user, settings['deployment']['deploy_user']
set :use_sudo, false

# Fix RVM
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

default_run_options[:pty] = true

#set :application, settings['deployment']['app_name']
#set :repository, settings['deployment']['repository']
#set :branch, settings['deployment']['branch']
set :scm, :git
ssh_options[:forward_agent] = true

#set :deploy_to, "#{settings['deployment']['path']}/#{settings['deployment']['app_name']}"
set :copy_exclude, %w".git spec"

# RVM
#set :rvm_ruby_string, settings['deployment']['rvm_ruby']
set :rvm_type, :system
# before 'deploy:setup', 'rvm:install_rvm'

# Whenever
require 'whenever/capistrano'
# set :whenever_command, "#{settings["deployment"]["bundle_wrapper_cmd"] || "bundle"} exec whenever"

# Unicorn
require 'capistrano-unicorn'
set :unicorn_bin, 'unicorn_rails'
# set :unicorn_bundle, settings['deployment']['bundle_wrapper_cmd']

# Delayed_job
require 'delayed/recipes'
set :rails_stage, rails_env

# server settings['deployment']['server'], :app, :web, :db, :primary => true

load 'config/recipes/db'

after 'deploy:finalize_update', 'db:migrate'
after 'deploy:start', 'unicorn:start'
after 'deploy:stop', 'unicorn:stop'
after 'deploy:stop', 'delayed_job:stop'
after 'deploy:start', 'delayed_job:start'
after 'deploy:restart', 'delayed_job:restart'
