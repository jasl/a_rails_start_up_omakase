class CommentsController < ApplicationController
  load_and_authorize_resource :comment

  def create
    @comment = commentable_record.comments.build params[:comment]
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to commentable_record, notice: 'Comment post successful.' }
        format.json { render json: @comment, status: :created, location: commentable_record }
      else
        format.html { render action: :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to commentable_record, :notice => 'Destroy comment successful' }
      format.json { head :no_content }
    end
  end

  def new
    respond_to do |format|
      format.html
      format.json { render json: @comment }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to commentable_record, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @comments = @comments.page params[:page]

    respond_to do |format|
      format.html
      format.json { render json: @comments }
    end
  end

  protected

  def commentable_record
    Post.find(params[:post_id])
  end

end
