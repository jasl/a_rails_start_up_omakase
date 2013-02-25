rails_env = 'staging'
settings = YAML.load_file('config/application.yml').fetch(rails_env)

app_dir = "#{settings['deployment']['path']}/#{settings['deployment']['app_name']}/current"

worker_processes settings['deployment']['worker_processes']
working_directory app_dir

# Load app into the master before forking workers for super-fast
# worker spawn times
preload_app true

# nuke workers after 60 seconds (the default)
timeout 30

# listen on a Unix domain socket and/or a TCP port,

#listen 8080 # listen to port 8080 on all TCP interfaces
listen '127.0.0.1:9090'  # listen to port 8080 on the loopback interface
# listen "/tmp/sockets/#{settings['deployment']['app_name']}_staging.sock", :backlog => 64

pid "#{app_dir}/tmp/pids/unicorn.pid"
stderr_path "#{app_dir}/log/unicorn.stderr.log"
stdout_path "#{app_dir}/log/unicorn.stdout.log"

# http://www.rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  old_pid = "#{server.config[:pid]}.oldbin"

  if File.exists?(old_pid) && server.pid != old_pid
    begin
      # sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      # Process.kill(sig, File.read(old_pid).to_i)
      Process.kill(:QUIT, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      puts "Send 'QUIT' signal to unicorn error!"
    end
  end
end

after_fork do |server, worker|
  # Unicorn master loads the app then forks off workers - because of the way
  # Unix forking works, we need to make sure we aren't using any of the parent's
  # sockets, e.g. db connection
  # when using deploy user running unicorn, this is already an low permission user,
  # so no need to spawn. if you still want to, remember update monit and other configs.
  #begin
  #  worker.user(user, group) if Process.euid == 0
  #rescue => e
  #  if ENV['RAILS_ENV'] == 'development'
  #    STDERR.puts "couldn't change user"
  #  else
  #    raise e
  #  end
  #end
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
  # Redis and Memcached would go here but their connections are established
  # on demand, so the master never opens a socket
  child_pid = server.config[:pid].sub('.pid', "_worker_#{worker.nr}.pid")
  system("echo #{Process.pid} > #{child_pid}")
end
