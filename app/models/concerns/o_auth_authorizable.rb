module OAuthAuthorizable
  extend ActiveSupport::Concern

  included do
    has_many :authorizations, :dependent => :destroy
  end

  def find_authorization(provider)
    authorizations.where(:provider => provider).first
  end

  def create_authorization(data)
    authorizations.create provider:data[:provider],
                          uid:data[:uid],
                          access_token:data[:access_token],
                          expires_at:data[:expires_at]
  end

  def build_authorization(data)
    authorizations.build provider:data[:provider],
                         uid:data[:uid],
                         access_token:data[:access_token],
                         expires_at:data[:expires_at]
  end

  module ClassMethods

  end
end
