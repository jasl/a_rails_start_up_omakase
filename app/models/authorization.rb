# -*- encoding : utf-8 -*-
class Authorization < ActiveRecord::Base
  belongs_to :user, :inverse_of => :authorizations

  validates :provider, :uid, :access_token, :expires_at, presence: true
  validates :provider, uniqueness: { scope: :user_id }

  delegate :post_status, :follow, :to => :@handler, :allow_nil => true

  after_find :mount_api_handler

  attr_accessible :provider, :uid, :access_token, :refresh_token, :url, :expires_at
  attr_accessible :provider, :uid, :access_token, :refresh_token, :url, :expires_at, :as => :admin

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
