# encoding: utf-8

# require 'carrierwave/processing/mini_magick' # no use when using upyun

class ImageUploader < BaseUploader
  self.upyun_bucket = Setting.upyun.images.bucket
  self.upyun_bucket_domain = Setting.upyun.images.bucket_domain

  # for extend
  def blank_image
    "blank.png"
  end

  # versions is already used
  # for extend
  def remote_versions
    Setting.upyun.images.versions
  end

  # doesn't define as default_url cause I want catch blank case in url method
  def blank_url
    asset_host = Rails.configuration.action_controller[:asset_host]
    if asset_host
      "http://#{asset_host}/assets/#{blank_image}"
    else
      "/assets/#{blank_image}"
    end
  end

  # Glory for huacnlee
  # 覆盖 url 方法以适应“图片空间”的缩略图命名
  def url(version_name = "")
    @url ||= super({})
    return blank_url if @url.blank?
    version_name = version_name.to_s
    return @url if version_name.blank?
    unless version_name.in?(remote_versions)
      # 故意在调用了一个没有定义的“缩略图版本名称”的时候抛出异常，以便开发的时候能及时看到调错了
      raise "ImageUploader version_name:#{version_name} not allow."
    end
    [@url,version_name].join(Setting.upyun.separator)
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
