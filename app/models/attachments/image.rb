# -*- encoding : utf-8 -*-
class Attachments::Image < Attachments::Base
  mount_uploader :data, ImageUploader, :mount_on => :store_name

end
