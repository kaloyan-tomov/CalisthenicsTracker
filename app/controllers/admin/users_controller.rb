module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!

    def index
      @users = User.order(:created_at)
    end

    def promote
      user = User.find(params[:id])
      user.admin!
      redirect_to admin_users_path, notice: "User promoted to admin"
    end

    def demote
      user = User.find(params[:id])
      user.trainee!
      redirect_to admin_users_path, notice: "User demoted to trainee"
    end

    def timeout
      user = User.find(params[:id])
      minutes = params[:minutes].to_i
      minutes = 10 if minutes <= 0

      user.update!(timeout_until: Time.current + minutes.minutes)
      redirect_to admin_users_path,
                  notice: "User timed out for #{minutes} minutes"
    end

    def clear_timeout
      user = User.find(params[:id])
      user.update!(timeout_until: nil)
      redirect_to admin_users_path, notice: "Timeout cleared"
    end
  end
end
