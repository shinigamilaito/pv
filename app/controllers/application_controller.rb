class ApplicationController < ActionController::Base
  layout :layout_by_resource
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :cash_services_sale_open?
  helper_method :cash_impression_open?

  protected

  def cash_services_sale_open?
    CashPolicy.new.cash_services_sales.present?
  end

  def cash_impression_open?
    CashPolicy.new.cash_impressions.present?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :first_name, :last_name, :username, :email, :password, :password_confirmation, :rol_id])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :first_name, :last_name, :username, :email, :password, :password_confirmation, :rol_id])
  end

  def route_wicked
    'C:/wkhtmltopdf/bin/wkhtmltopdf.exe'
  end

  def elements_per_page
    return 20
  end

  def obtain_index(page)
    total_rows = (page || 0) * self.elements_per_page

    if total_rows > 0
      return total_rows - self.elements_per_page + 1
    else
      return 1
    end
  end

  private

  def layout_by_resource
  	if devise_controller? && (params[:action].eql?('new') || params[:action].eql?('create'))
  		'devise'
  	else
  		'application'
  	end
  end

end
