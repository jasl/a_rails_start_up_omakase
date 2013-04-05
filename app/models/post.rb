class Post < ActiveRecord::Base
  acts_as_commentable

  belongs_to :user

  default_scope :order => 'id DESC'

  attr_accessible :body, :title
  attr_accessible :body, :title, :state, :as => :admin
end
