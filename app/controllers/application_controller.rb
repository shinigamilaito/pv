class ApplicationController < ActionController::Base
  layout :layout_by_resource
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected  

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :first_name, :last_name, :username, :email, :password, :password_confirmation, :rol_id])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :first_name, :last_name, :username, :email, :password, :password_confirmation, :rol_id])
  end

  private

  def layout_by_resource
  	if devise_controller? && (params[:action].eql?('new') || params[:action].eql?('create'))
  		"devise"
  	else
  		"application"
  	end
  end

end
