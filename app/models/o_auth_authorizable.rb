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
end
