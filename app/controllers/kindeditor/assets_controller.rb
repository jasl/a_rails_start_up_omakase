#coding: utf-8
class Kindeditor::AssetsController < ::ApplicationController
  before_filter :require_current_user
  skip_before_filter :verify_authenticity_token

  def create
    unless params[:imgFile]
      render json: {error: 1, message: "No File Selected!"}
      return
    end

    asset = ::Attachments::Image.new
    asset.data = params[:imgFile]
    asset.set_assetable! current_user.class.model_name, current_user.id

    if asset.save
      render json: {error: 0, url: asset.data.url}
    else
      render json: {error: 1, message: asset.errors}
    end
  end

  private

  def require_current_user
    render json: {error: 1, message: "No File Selected!"}, :status => 403 unless current_user
  end
end
