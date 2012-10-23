class Users::ProfilesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]

  def update_profile
    if current_user.update_attributes(params[:user])
      flash[:notice] = t('devise.registrations.updated')
      redirect_to root_path
    else
      render "devise/registrations/edit"
    end
  end

  def show
    @user = User.find params[:id]
    render "devise/registrations/show"
  end
end
