module OAuthAuthorizable
  extend ActiveSupport::Concern

  included do
    has_many :authorizations, :dependent => :destroy
  end

  Devise.omniauth_providers.each do |provider|
    class_eval <<-EVAL
      def find_#{provider}_authorization
        self.authorizations.where(:provider => '#{provider}').first
      end
    EVAL
  end

  class_eval <<-EVAL
    def create_authorization(data)
      self.authorizations.create provider:data[:provider],
                                 uid:data[:uid],
                                 access_token:data[:access_token],
                                 expires_at:data[:expires_at]
    end
  EVAL

end
