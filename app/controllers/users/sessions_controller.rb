class Users::SessionsController < Devise::SessionsController
  rate_limit to: 10,
             within: 3.minutes,
             only: :create,
             with: -> { redirect_to login_path, alert: "Too many login attempts. Try again later." }

  def create
    user = User.find_by(email: params[:user][:email], username: params[:user][:username])

    if user.nil? || !user.valid_password?(params[:user][:password])
      flash[:alert] = "Invalid username, email, or password."
      redirect_to login_path and return
    end

    unless user.confirmed?
      flash[:alert] = "Please confirm your email address before signing in."
      redirect_to login_path and return
    end

    flash[:notice] = "Welcome back, #{user.username}!"
    sign_in(user)
    redirect_to root_path
  end
end
