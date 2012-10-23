# -*- encoding : utf-8 -*-
class Location < ActiveRecord::Base
  attr_accessible :province, :city, :district

  def full
    "#{self.province} #{self.city} #{self.district}"
  end

end
