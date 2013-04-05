module Users::RegistrationsHelper
  def active_bind_tab?
    params[:type] == 'bind'
  end
end
