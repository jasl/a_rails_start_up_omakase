class Post < ActiveRecord::Base
  acts_as_commentable

  belongs_to :user
  attr_accessible :body, :title
end
