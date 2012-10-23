# -*- encoding : utf-8 -*-
class Attachments::Base < ActiveRecord::Base
  self.table_name = 'assets'

  validates :data, :presence => true

  attr_accessible :data, :data_cache, :description, :extra

  after_initialize :generate_access_token

  before_save :update_asset_attributes
  before_update :update_asset_attributes

  belongs_to :assetable, :polymorphic => true

  attr_accessible :description

  def set_assetable!(type, id)
    self.assetable_type = type
    self.assetable_id = id
  end

  scope :find_by_assetable, ->(type, id) { where :assetable_type => type, :assetable_id => id }

  protected

  def update_asset_attributes
    self.content_type ||= data.file.content_type
    # can not get these when use upyun
    # self.file_size = data.file.size
  end

  def generate_access_token
    #for future extensive
    self.access_token = SecureRandom.uuid.gsub("-","")
  end

end
