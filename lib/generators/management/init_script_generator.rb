require "rake/file_utils"

module Management
  class InitScriptGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc "Creates a init.d shell and copy to bin folder."
    def init_script
      template 'init_script.erb', "bin/#{Setting.deployment.app_name}"
      FileUtils::chmod "u=wrx,go=rx", "bin/#{Setting.deployment.app_name}"
    end
  end

end
