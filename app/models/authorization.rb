# -*- encoding : utf-8 -*-
class Authorization < ActiveRecord::Base
  belongs_to :user, :inverse_of => :authorizations

  validates :provider, :uid, :access_token, presence: true
  validates :provider, uniqueness: { scope: :user_id }
  validates :uid, uniqueness: { scope: :provider }

  delegate :post_status, :follow, :to => :@handler, :allow_nil => true

  after_find :mount_api_handler

  attr_accessible :provider, :uid, :access_token, :refresh_token, :url, :expires_at
  attr_accessible :provider, :uid, :access_token, :refresh_token, :url, :expires_at, :as => :admin

  class<< self
    def find_by_provider_and_uid(provider, uid)
      where(provider: provider, uid: uid.to_s).first
    end
  end

  private

  # obj factory
  def mount_api_handler
    case self.provider
      when 'weibo'
        @handler = WeiboHandler.new self
      when 'xiaonei'
        @handler = XiaoneiHandler.new self
      else @handler = nil
    end
  end
end
