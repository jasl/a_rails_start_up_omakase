class ApplicationController < ActionController::Base

  protect_from_forgery

  protected

  # some bots using some *strange* format to request urls
  # that would trigger missing template exception,
  # so this will reject those request, but you can adjust to your logic
  if Rails.env.production?
    rescue_from ActionView::MissingTemplate do
      head :not_acceptable
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_path
  end

  protected

  # compatible with devise so key named "user_return_to"
  def store_location
    session['user_return_to'] = request.original_url
  end

  def redirect_back_or_default(default)
    redirect_to(session['user_return_to'] || default)
    session.delete 'user_return_to'
  end

end
