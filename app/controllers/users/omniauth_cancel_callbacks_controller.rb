# -*- encoding : utf-8 -*-
class Users::OmniauthCancelCallbacksController < ::ActionController::Base

  def weibo
    # Sina NYI
    redirect_to root_path
  end

  def xiaonei
    if record = Authorization.where(:uid => params[:xn_sig_user]).first
      record.destroy
    end

    redirect_to root_path
  end

end
