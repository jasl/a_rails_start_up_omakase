require 'rake/file_utils'

module Conf
  class DelayedJobGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'Creates a delayed_job init.d script and copy to bin folder.'
    def unicorn
      template 'delayed_job.erb', "bin/delayed_job_#{Setting.deployment.app_name}"
      FileUtils::chmod 'u=wrx,go=rx', "bin/delayed_job_#{Setting.deployment.app_name}"
    end
  end

end
