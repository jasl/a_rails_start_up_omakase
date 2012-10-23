# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable #, omniauth_providers: [:weibo]
  include Devise::Async::Model

  attr_accessible :email, :password, :password_confirmation, :remember_me
  validates :email, :uniqueness => true
  has_many :authorizations, :dependent => :destroy
  belongs_to :location, :readonly => true

  # profile
  attr_accessible :nickname, :name, :phone, :location_id, :gender

  after_create :send_welcome_mail

  def admin?
    self.role == "admin"
  end

  default_scope { where :state == :active }

  private

  def send_welcome_mail
    UserMailer.welcome(self.id).deliver!
  end

  def required_email_or_username
    if email.blank? and username.blank?
      errors.add(:email, :blank)
    end
  end
end
