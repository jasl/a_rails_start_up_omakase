# encoding: utf-8

# require 'carrierwave/processing/mini_magick'

class AvatarUploader < ImageUploader

  def blank_image
    'avatar.png'
  end

  def extension_white_list
    ['jpg', 'jpeg', 'gif', 'png', '']
  end
end
