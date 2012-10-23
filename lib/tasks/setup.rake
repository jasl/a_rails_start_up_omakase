namespace :app do
  namespace :service do
    desc "Generate linux service script to help control app server."
    task :generate do
      system "rails g script_generator"
    end

    desc "Put the service script into /etc/init.d and register it auto start."
    task :register do
      system "sudo cp bin/startup_server /etc/init.d/ && chkconfig startup_server on"
    end

    desc "Generate linux service script and register it auto start."
    task :setup => %w"app:service:generate app:service:register"
  end
end
