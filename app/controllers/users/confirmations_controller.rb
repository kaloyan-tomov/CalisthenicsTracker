class Users::ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      redirect_to login_path, notice: "Your email is confirmed. You can sign in now."
      return
    end

    message = if resource.errors.added?(:confirmation_token, :invalid)
                "This confirmation link is invalid or has expired."
              else
                resource.errors.full_messages.to_sentence
              end

    redirect_to login_path, alert: message
  end
end
