# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :async #, omniauth_providers: [:weibo]
  include OAuthAuthorizable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  validates :email, :uniqueness => true

  after_create :send_welcome

  # profile
  mount_uploader :avatar, AvatarUploader
  attr_accessible :nickname, :gender, :description, :avatar, :avatar_cache, :province, :city, :district
  attr_accessible :nickname, :gender, :description, :avatar, :avatar_cache, :province, :city, :district,
                  :as => :admin

  def admin?
    self.role == 'admin'
  end

  default_scope { where :state == :active }

  def location
    District.try_nested_get :province => self.province,
                            :city => self.city,
                            :district => self.district,
                            :prepend_parent => true
  end

  def to_s
    @display_name ||= self.nickname.blank? ? self.email.split('@')[0] : self.nickname
  end

  def set_profiles_by_oauth(info)
    self.nickname = info[:nickname] if self.nickname.blank?
    self.description = info[:description] if self.description.blank?
    if self.avatar.blank? and not info[:image].blank?
      begin
        tmp = Tempfile.new 'avatar', :encoding => 'ascii-8bit'
        tmp.write open(info[:image]).read
        self.avatar.store! tmp
      rescue Exception => ex
        logger.log info[:image]
        logger.log ex
      end
    end
  end

  private

  def send_welcome
    UserMailer.welcome(self).deliver
  end

end
