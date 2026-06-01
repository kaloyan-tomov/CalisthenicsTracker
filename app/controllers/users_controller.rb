class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:query].present?
      @users = User.where(
        "username LIKE :q OR email LIKE :q",
        q: "%#{params[:query]}%"
      )
    else
      @users = User.all
    end
  end

  def edit_profile
    @user = current_user
  end

  def update_profile
    @user = current_user

    if @user.update(profile_params)
      flash[:notice] = "Profile updated!"
      redirect_to root_path
    else
      flash[:alert] = @user.errors.full_messages.join(", ")
      redirect_to profile_edit_path
    end
  end

  def edit_password
    @user = current_user
  end

  def update_password
    @user = current_user

    if @user.update_with_password(password_params)
      bypass_sign_in(@user)
      flash[:notice] = "Password updated successfully."
      redirect_to root_path
    else
      flash[:alert] = @user.errors.full_messages.join(", ")
      render :edit_password, status: :unprocessable_entity
    end
  end

  private
  
  def profile_params
    params.require(:user).permit(:username)
  end

  def password_params
    params.require(:user)
          .permit(:current_password, :password, :password_confirmation)
  end
end
