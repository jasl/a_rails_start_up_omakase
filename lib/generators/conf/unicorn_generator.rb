require 'rake/file_utils'

module Conf
  class UnicornGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'Creates a unicorn init.d script and copy to bin folder.'
    def unicorn
      template 'unicorn.erb', "bin/unicorn_#{Setting.deployment.app_name}"
      FileUtils::chmod "u=wrx,go=rx", "bin/unicorn_#{Setting.deployment.app_name}"
    end
  end

end
