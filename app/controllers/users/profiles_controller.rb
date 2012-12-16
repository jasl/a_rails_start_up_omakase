class Users::ProfilesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]

  def update
    respond_to do |format|
      if current_user.update_attributes(params[:user])
        format.html { redirect_to root_path, notice: t('devise.registrations.updated') }
        format.json { head :no_content }
      else
        format.html { render "devise/registrations/edit" }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @user = User.find params[:id]

    respond_to do |format|
      format.html { render "devise/registrations/show" }
      format.json { render json: @user }
    end
  end
end
