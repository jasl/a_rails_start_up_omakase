# encoding: utf-8

class FileUploader < BaseUploader
  self.upyun_bucket = Setting.upyun.files.bucket
  self.upyun_bucket_domain = Setting.upyun.files.bucket_domain
end
