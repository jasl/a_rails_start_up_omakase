# -*- encoding : utf-8 -*-
class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, :only => [ :bind, :binding ]
  prepend_before_filter :allow_params_authentication!, :only => [:bind]
  before_filter :require_oauth_and_not_bound, :only => [:bind, :binding]

  # binding info post to here
  def bind
    data = session[:omniauth]
    case params[:type]
      when "regist" then
        build_resource params[:user]
      when "bind" then
        self.resource = warden.authenticate!(auth_options)
        if resource.authorizations.where(provider: data[:provider]).exists?
          session.delete :omniauth
          # when user existed and given the right password, and already bind the authorization
          set_flash_message :notice, t('devise.registrations.oauth_already_bind')
          redirect_to new_user_session_path
        end
      else
        redirect_to new_user_registration_path
    end
    self.resource.build_authorization data

    if self.resource.save
      session.delete :omniauth
      if self.resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, self.resource)
        respond_with self.resource, :location => after_sign_up_path_for(self.resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with self.resource, :location => after_inactive_sign_up_path_for(self.resource)
      end
    else
      clean_up_passwords self.resource
      respond_with self.resource do |format|
        format.html { render 'devise/registrations/binding' }
      end
    end
  end

  def binding
    if session[:omniauth]
      resource = build_resource(params[:user] || info_from_omniauth)
      respond_with resource
    else
      set_flash_message :notice, t('devise.registrations.oauth_failure')
      redirect_to new_user_session_path
    end
  end

  protected

  def require_oauth_and_not_bound
    # omniauth session lost or authorization exists
    unless session[:omniauth] or Authorization.where(provider: data[:provider], uid: data[:uid]).exists?
      set_flash_message :notice, t('devise.registrations.oauth_failure')
      redirect_to new_user_registration_path
    end
  end

  def info_from_omniauth
    (session[:omniauth].blank? or session[:omniauth][:info].blank?) ?
        {} : session[:omniauth][:info]
  end

  def auth_options
    { :scope => resource_name, :recall => "#{controller_path}#binding" }
  end
end
