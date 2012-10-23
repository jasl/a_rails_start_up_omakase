class Admin::ApplicationController < ::ActionController::Base
  before_filter :authenticate_admin

  layout 'admin/application'

  protect_from_forgery

  protected

  def authenticate_admin
    unless current_user and current_user.admin?
      logger.info "IP: #{request.remote_ip} tried to access admin page at #{Time.now.to_s}"
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end
end
