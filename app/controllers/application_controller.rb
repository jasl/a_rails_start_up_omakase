class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :log_agent

  protected

  def log_agent
    logger.info "HTTP_USER_AGENT #{request.env["HTTP_USER_AGENT"]}"
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

end
