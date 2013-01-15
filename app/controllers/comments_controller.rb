class CommentsController < ApplicationController
  load_and_authorize_resource :through => :current_entry

  def create
    @comment = current_entry.comments.build params[:comment]
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to current_entry, notice: 'Comment post successful.' }
        format.json { render json: @comment, status: :created, location: current_entry }
      else
        format.html { render action: :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    current_entry.comments.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to current_entry, :notice => 'Destroy comment successful' }
      format.json { head :no_content }
    end
  end

  protected

  def current_entry
    Post.find(params[:post_id])
  end

end
