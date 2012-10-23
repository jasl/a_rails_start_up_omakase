class CommentsController < ApplicationController
  load_and_authorize_resource

  def create
    comment = current_post.comments.build params[:comment]
    comment.user = current_user
    comment.save!

    redirect_to post_path(params[:post_id]), :notice => 'Comment post successful'
  end

  def destroy
    current_post.comments.find(params[:id]).destroy
    redirect_to post_path(params[:post_id]), :notice => 'Delete comment successful'
  end

  private
  def current_post
    Post.find(params[:post_id])
  end
end
