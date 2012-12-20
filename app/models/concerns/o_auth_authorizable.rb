module OAuthAuthorizable
  extend ActiveSupport::Concern

  included do
    has_many :authorizations, :dependent => :destroy
  end

  Devise.omniauth_providers.each do |provider|
    define_method :"find_#{provider}_authorization" do
      authorizations.where(:provider => provider).first
    end
  end

  define_method :create_authorization do |data|
    authorizations.create provider:data[:provider],
                          uid:data[:uid],
                          access_token:data[:access_token],
                          expires_at:data[:expires_at]
  end

end
