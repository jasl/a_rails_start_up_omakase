module Management
  class LogrotateConfGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc "Creates a basic logrotate conf and copy to conf folder."
    def logrotate_conf
      template 'logrotate.conf.erb', "conf/logrotate.conf"
    end
  end

end
