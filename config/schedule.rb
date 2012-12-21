# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end
require 'pathname'

puts Pathname.new(__FILE__).realpath.dirname

setting = YAML.load_file("#{Pathname.new(__FILE__).realpath.dirname}/application.yml").fetch('production')
app_path = "#{setting["deployment"]["path"]}/#{setting["deployment"]["app_name"]}/current"

set :output, "#{app_path}/log/cron_log.log"

every 1.days do
  command %W(sudo -u #{setting["deployment"]["deploy_user"]} #{setting["deployment"]["bundle_wrapper_cmd"]} exec \
               backup perform -t backup_site -r #{app_path}/config/backup \
               -l #{app_path}/log --tmp-path=#{app_path}/tmp/backup --cache-path=#{app_path}/tmp/cache/backup \
               -d #{app_path}/tmp/backup)
end

# Learn more: http://github.com/javan/whenever
