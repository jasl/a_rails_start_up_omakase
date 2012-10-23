# -*- encoding : utf-8 -*-
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def after_omniauth_failure_path_for(scope)
    set_flash_message(:notice, :failure)
    super
  end

  def weibo
    omniauth = request.env['omniauth.auth']
    location = omniauth.info.location.split ' '
    data = {provider: omniauth.provider,
            uid: omniauth.uid,
            access_token: omniauth.credentials.token,
            expires_at: omniauth.credentials.expires_at,
            info: {
                nickname: omniauth.info.nickname,
                name: omniauth.info.name,
                province: location[0],
                city: location[1]
            }}

    processing_oauth data
  end

  def xiaonei
    omniauth = request.env['omniauth.auth']
    data = {provider: omniauth.provider,
            uid: omniauth.uid,
            access_token: omniauth.credentials.token,
            refresh_token: omniauth.credentials.refresh_token,
            expires_at: omniauth.credentials.expires_at,
            info: {
                name: omniauth.info.name,
            }}

    processing_oauth data
  end

  private

  def processing_oauth(data)
    if authorization = Authorization.where(provider: data[:provider], uid: data[:uid].to_s).first
      #to refresh token if its expired
      if data[:access_token] != authorization.access_token
        authorization.access_token = data[:access_token]
        authorization.expires_at = data[:expires_at]
        authorization.save!
      end

      set_flash_message(:notice, :signed_in)
      sign_in(:user, authorization.user)
      redirect_to root_path
    elsif current_user
      current_user.authorizations.create provider:data[:provider],
                                         uid:data[:uid],
                                         access_token:data[:access_token],
                                         expires_at:data[:expires_at]
      redirect_to root_path
    else
      session[:omniauth] = data

      set_flash_message(:notice, :success, :kind => data[:provider])
      redirect_to user_binding_path
    end
  end
end
