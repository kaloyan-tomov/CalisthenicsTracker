class Users::RegistrationsController < Devise::RegistrationsController
  rate_limit to: 5,
             within: 1.hour,
             only: :create,
             with: -> { redirect_to new_user_registration_path, alert: "Too many registration attempts. Try again later." }

  before_action :configure_sign_up_params, only: [:create]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
