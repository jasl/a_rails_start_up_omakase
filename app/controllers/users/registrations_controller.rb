# -*- encoding : utf-8 -*-
class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :must_not_sign_in, :only => [:bind, :binding]

  def bind
    # binding info posted here
    if data = session[:omniauth] and not Authorization.where(provider: data[:provider], uid: data[:uid]).exists?
      # authorization not exists
      resource = User.find_by_email(params[:user][:email])
      if resource.nil? or not resource.valid_password?(params[:user][:password])
        # user not exists
        # or user existed but given a wrong password,
        #    in this case will continue but should trigger presence validation false when save.
        build_resource
      elsif resource.authorizations.where(provider: data[:provider]).exists?
        # when user existed and given the right password, and already bind the authorization
        set_flash_message :notice, t('devise.registrations.oauth_already_bind')
        return redirect_to new_user_session_path
      else
        # new user
        self.resource = resource
      end

      self.resource.nickname ||= data[:info][:nickname]
      self.resource.name ||= data[:info][:name]
      self.resource.authorizations.build provider: data[:provider],
                                         uid: data[:uid],
                                         access_token: data[:access_token],
                                         expires_at: data[:expires_at],
                                         refresh_token: data[:refresh_token]

      if self.resource.save
        if self.resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_navigational_format?
          sign_in(resource_name, self.resource)
          session.delete :omniauth
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
    else
      # authorization exists
      set_flash_message :notice, t('devise.registrations.oauth_failure')
      redirect_to new_user_session_path
    end
  end

  def binding
    if session[:omniauth]
      resource = build_resource()
      respond_with resource
    else
      set_flash_message :notice, t('devise.registrations.oauth_failure')
      redirect_to new_user_session_path
    end
  end

  private
  def must_not_sign_in
    redirect_to root_path if current_user
  end
end
