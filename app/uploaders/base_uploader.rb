# encoding: utf-8

class BaseUploader < CarrierWave::Uploader::Base
  storage :upyun
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
