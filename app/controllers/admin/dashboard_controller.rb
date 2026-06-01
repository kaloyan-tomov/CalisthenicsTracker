class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def index
    @users = User.all.order(:id)
  end
end
