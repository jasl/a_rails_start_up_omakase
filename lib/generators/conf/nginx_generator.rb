module Conf
  class NginxGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc "Creates a basic nginx conf and copy to conf folder."
    def nginx_conf
      template 'nginx.conf.erb', "conf/nginx.#{Setting.deployment.app_name}.conf"
    end
  end

end
