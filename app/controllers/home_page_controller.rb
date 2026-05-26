class HomePageController < ApplicationController
  rate_limit to: 5,
             within: 1.hour,
             only: :create_user,
             with: -> { redirect_to register_path, alert: "Too many registration attempts. Try again later." }

  def index
  end

  def login
  end

  def register
    @user = User.new
  end

  def create_user
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "Account created. Please check your email to confirm your address before signing in."
      redirect_to login_path
    else
      flash[:alert] = @user.errors.full_messages.join(", ")
      render :register, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
