#coding: utf-8
class Ueditor::AssetsController < ::ApplicationController
  before_filter :authenticate_user!
  # skip_before_filter :verify_authenticity_token

  def image
    unless params[:upfile]
      render json: {error: 1, message: "No File Selected!"}
      return
    end

    asset = ::Attachments::Image.new
    asset.data = params[:upfile]
    asset.set_assetable! current_user.class.model_name, current_user.id

    if asset.save!
      render json: {url: asset.data.url,
                    name: asset.store_name,
                    title: "pic",
                    original: asset.store_name,
                    state: "SUCCESS"}
    else
      render json: {state: "UNKNOWN"}
    end
  end

  def file
    unless params[:upfile]
      render json: {error: 1, message: "No File Selected!"}
      return
    end

    asset = ::Attachments::File.new
    asset.data = params[:upfile]
    asset.set_assetable! current_user.class.model_name, current_user.id

    if asset.save!
      render json: {url: asset.data.url,
                    name: asset.store_name,
                    title: "pic",
                    original: asset.store_name,
                    state: "SUCCESS"}
    else
      render json: {state: "UNKNOWN"}
    end
  end

end
