require "rake/file_utils"

class ScriptGeneratorGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def gen_service_script
    template 'startup_server.erb', 'bin/startup_server'
    FileUtils::chmod "u=wrx,go=rx", "bin/startup_server"
  end
end

