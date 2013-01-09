# -*- encoding : utf-8 -*-
class Users::OmniauthCancelCallbacksController < DeviseController

  def self.provides_cancel_callback_for(*args)
    args[0].each do |provider, uid|
      class_eval <<-EVAL, __FILE__, __LINE__ + 1
        def #{provider}
          if record = Authorization.where(:provider => #{provider}, :uid => params[:#{uid}]).first
            record.destroy
          end

          head :no_centent
        end
      EVAL
    end
  end

  provides_cancel_callback_for :xiaonei => :xn_sig_user

end
