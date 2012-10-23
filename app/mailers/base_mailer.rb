class BaseMailer < ActionMailer::Base
  include Resque::Mailer

  default :from => Setting.mailer.sender
  default :charset => "utf-8"
  default :content_type => "text/html"
  default_url_options[:host] = Setting.domain

  layout 'mailer'
end
