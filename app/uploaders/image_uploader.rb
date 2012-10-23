# encoding: utf-8

# require 'carrierwave/processing/mini_magick'

# Glory for huacnlee

class ImageUploader < BaseUploader

  def default_url
    asset_host = Rails.configuration.action_controller[:asset_host]
    if asset_host
      "http://#{self.upyun_bucket_domain}/assets/blank.png"
    else
      "/assets/blank.png"
    end
  end

  # 覆盖 url 方法以适应“图片空间”的缩略图命名
  def url(version_name = "")
    @url ||= super({})
    version_name = version_name.to_s
    return @url if version_name.blank?
    unless version_name.in?(Setting.upyun.images.versions)
      # 故意在调用了一个没有定义的“缩略图版本名称”的时候抛出异常，以便开发的时候能及时看到调错了
      raise "ImageUploader version_name:#{version_name} not allow."
    end
    [@url,version_name].join(Setting.upyun.separator)
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
