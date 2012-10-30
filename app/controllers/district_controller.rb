# encoding: utf-8
class DistrictController < ApplicationController
  layout nil

  def show
    @result = District.list(params[:id])
    render :text => @result
  end
end
