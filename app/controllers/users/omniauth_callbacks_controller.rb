# -*- encoding : utf-8 -*-
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  INFO = %w(nickname image description)

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
                     #{INFO.collect {|f| "#{f}: omniauth.info.#{f}"}.join(',')}
                   }
                  }

          if authorization = Authorization.find_by_provider_and_uid(data[:provider], data[:uid])
            if data[:access_token] != authorization.access_token
              authorization.update_attributes! access_token: data[:access_token],
                                               expires_at: data[:expires_at]
            end

            user = authorization.user
            set_flash_message(:notice, :signed_in)
            sign_in_and_redirect user
          elsif current_user
            current_user.create_authorization data

            after_sign_in_path_for(current_user)
          else
            session[:omniauth] = data

            set_flash_message(:notice, :success, :kind => data[:provider])
            redirect_to users_binding_path(:type => :new)
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
