class ErrorsController < ApplicationController
  def not_found

    respond_to do |format|
      format.html { render :status => 404 }
      format.json { render :status => 404 }
    end
  end

  def error_occurred

    respond_to do |format|
      format.html { render :status => 500 }
      format.json { render :status => 500 }
    end
  end

end
