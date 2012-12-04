# encoding: utf-8

class BaseUploader < CarrierWave::Uploader::Base
  storage CarrierWave::Storage::UpYun

  self.upyun_bucket = Setting.upyun.images.bucket
  self.upyun_bucket_domain = Setting.upyun.images.bucket_domain
  self.upyun_username = Setting.upyun.username
  self.upyun_password = Setting.upyun.password

  def store_dir
    "#{model.class.to_s.underscore}/#{mounted_as}"
  end

  def filename
    if super.present?
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}#{File.extname(original_filename).downcase}"
    end
  end

end
