class ApplicationController < ActionController::Base
  self.without_modules ActionController::Compatibility

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

  def render_404
    render_optional_error_file(404)
  end

  def render_403
    render_optional_error_file(403)
  end

  def render_optional_error_file(status_code)
    status = status_code.to_s
    if %w(404 403 422 500).include?(status)
      render :template => "/errors/#{status}", :format => [:html], :handler => [:erb], :status => status, :layout => "application"
    else
      render :template => "/errors/500", :format => [:html], :handler => [:erb], :status => status, :layout => "application"
    end
  end

end
