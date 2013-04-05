class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  default_scope :order => 'id DESC'

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user

  validates :body, :presence => true

  attr_accessible :body, :title

  attr_accessible :body, :title, :state, :as => :admin
end
