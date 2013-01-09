# -*- encoding : utf-8 -*-
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def self.provides_callback_for(*providers)
    providers.each do |provider|
      class_eval <<-EVAL, __FILE__, __LINE__ + 1
        def #{provider}
          omniauth = request.env['omniauth.auth']

          data = { provider: omniauth.provider,
                   uid: omniauth.uid,
                   access_token: omniauth.credentials.token,
                   expires_at: omniauth.credentials.expires_at,
                   refresh_token: omniauth.credentials.refresh_token,
                   info: {
                     name: omniauth.info.name,
                     nickname: omniauth.info.nickname,
                     email: omniauth.info.email
                   }
          }

          if authorization = Authorization.where(provider: data[:provider], uid: data[:uid].to_s).first
            if data[:access_token] != authorization.access_token
              authorization.update_attributes! access_token: data[:access_token],
                                               expires_at: data[:expires_at]
            end

            set_flash_message(:notice, :signed_in)
            sign_in(:user, authorization.user)
            redirect_to root_path
          elsif current_user
            current_user.create_authorization data

            redirect_to root_path
          else
            session[:omniauth] = data

            set_flash_message(:notice, :success, :kind => data[:provider])
            redirect_to users_binding_path(:type => :regist)
          end
        end
      EVAL
    end
  end

  provides_callback_for :xiaonei, :weibo

  # This is solution for existing accout want bind Google login but current_user is always nil
  # https://github.com/intridea/omniauth/issues/185
  def handle_unverified_request
    true
  end

  def after_omniauth_failure_path_for(scope)
    failure
    super
  end
end
