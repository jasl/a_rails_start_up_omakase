module Conf
  class MonitGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc "Creates a basic monit conf and copy to conf folder."
    def monit_conf
      template 'monit.conf.erb', "conf/monit.#{Setting.deployment.app_name}.conf"
    end
  end

end
