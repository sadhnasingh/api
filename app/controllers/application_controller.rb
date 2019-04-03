class ApplicationController < ActionController::Base
	before_action :authenticate_user!
	 before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user|
      user.permit(:email, :password,:password_confirmation, :remember_me)
    end
    devise_parameter_sanitizer.permit(:sign_in) do |user|
      user.permit(:email, :password)
    end
    devise_parameter_sanitizer.permit(:account_update) do |user|
      user.permit(:email, :password,:password_confirmation, :current_password)
    end
  end
end
