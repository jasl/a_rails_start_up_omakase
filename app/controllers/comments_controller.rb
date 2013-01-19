class CommentsController < ApplicationController
  load_and_authorize_resource :comment, :through => :commentable_entry

  def create
    @comment = commentable_entry.comments.build params[:comment]
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to commentable_entry, notice: 'Comment post successful.' }
        format.json { render json: @comment, status: :created, location: commentable_entry }
      else
        format.html { render action: :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    commentable_entry.comments.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to commentable_entry, :notice => 'Destroy comment successful' }
      format.json { head :no_content }
    end
  end

  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  protected

  def commentable_entry
    Post.find(params[:post_id])
  end

end
