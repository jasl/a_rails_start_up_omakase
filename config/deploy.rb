# Encoding: utf-8
require "capistrano_colors"
require "sushi/ssh"
require "bundler/capistrano"
require "rvm/capistrano"
load 'deploy/assets'

# load airbrake
# require './config/boot'
# require 'airbrake/capistrano'

def su(*parameters)
  options = parameters.last.is_a?(Hash) ? parameters.pop.dup : {}
  command = parameters.first
  user = options[:as] && "-l #{options.delete(:as)}"
  @password ||= fetch(:su_password, nil) || fetch(:root_password, Capistrano::CLI.password_prompt("root password: "))

  if command
    command = "su - #{user} -c '#{command}'"
    run command do |channel, stream, output|
      channel.send_data("#{@password}\n") if output
      puts output
    end
  else
    command
  end
end

# Runs +command+ as root invoking the command with su -c
# and handling the root password prompt.
#
#   try_su "/etc/init.d/apache reload"
#   # Executes
#   # su - -c '/etc/init.d/apache reload'
#
def try_su(*args)
  options = args.last.is_a?(Hash) ? args.pop : {}
  command = args.shift
  raise ArgumentError, "too many arguments" if args.any?

  as = options.fetch(:as, fetch(:su_runner, nil)) || 'root'
  su(command, :as => as)
end

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
# set :rvm_ruby_string, settings["deployment"]["rvm_ruby"]
set :rvm_type, :system
# before 'deploy:setup', 'rvm:install_rvm'

# Resque
require "capistrano-resque"
# role :resque_worker, "app_domain"
# role :resque_scheduler, "app_domain"
set :workers, settings["resque"]["queues"]

# Unicorn
require 'capistrano-unicorn'
set :unicorn_bin, 'unicorn_rails'
set :unicorn_bundle, settings["deployment"]["bundle_wrapper_cmd"]

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

after "deploy:restart", "resque:restart"

after 'deploy:start', 'resque:start'
after 'deploy:start', 'resque:scheduler:start'
after 'deploy:start', 'unicorn:start'

after 'deploy:stop', 'unicorn:stop'
after 'deploy:stop', 'resque:scheduler:stop'
after 'deploy:stop', 'resque:stop'
