# Encoding: utf-8
require "capistrano_colors"
require "sushi/ssh"
require "bundler/capistrano"
require "rvm/capistrano"
load 'deploy/assets'

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

server settings["deployment"]["server"], :app, :web, :db, :primary => true

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

after "deploy:assets:precompile", 'deploy:assets:sync_to_cdn'

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

# You need edit sudoer to give deployment user sudo /sbin/service permission and set no need password
# e.g: worker ALL = NOPASSWD:/sbin/service
namespace :service do
  desc "Setup application server"
  task :setup, :role => :app do
    run "cd #{latest_release}; bundle exec rake app:service:generate"
    try_su "cp #{latest_release}/bin/startup_server /etc/init.d/ -f"
    try_su "chmod +x /etc/init.d/startup_server"
  end

  desc "Start application server"
  task :start, :roles => :app do
    run "sudo service startup_server start"
  end

  desc "Stop application server"
  task :stop, :roles => :app do
    run "sudo service startup_server stop"
  end

  desc "Restart application server"
  task :restart, :roles => :app  do
    run "sudo service startup_server restart"
  end
end

#after "deploy:create_symlink", "service:setup"
after "deploy:create_symlink", "service:restart"
