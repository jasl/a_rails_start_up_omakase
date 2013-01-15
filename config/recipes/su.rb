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
