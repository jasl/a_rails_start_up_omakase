module Users::RegistrationsHelper
  def active_bind_tab?(method)
    params[:type] == method
  end
end
