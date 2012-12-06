# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :async #, omniauth_providers: [:weibo]

  attr_accessible :email, :password, :password_confirmation, :remember_me
  validates :email, :uniqueness => true
  has_many :authorizations, :dependent => :destroy

  # profile
  attr_accessible :nickname, :name, :phone, :location_id, :gender
  attr_accessible :province, :city, :district

  attr_accessible :nickname, :name, :phone, :location_id, :gender, :province, :city, :district, :as => :admin

  after_create :send_welcome_mail

  def admin?
    self.role == "admin"
  end

  default_scope { where :state == :active }

  def location
    District.try_nested_get :province => self.province,
                            :city => self.city,
                            :district => self.district,
                            :prepend_parent => true
  end

  def to_s
    @nickname ||= self.nickname.blank? ? self.email.split('@')[0] : self.nickname
  end

  private

  def send_welcome_mail
    UserMailer.welcome(self.id).deliver!
  end
end
