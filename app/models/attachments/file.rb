# -*- encoding : utf-8 -*-
class Attachments::File < Attachments::Base
  mount_uploader :data, FileUploader, :mount_on => :store_name

end
