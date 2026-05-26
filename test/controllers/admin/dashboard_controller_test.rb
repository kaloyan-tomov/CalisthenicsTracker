require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "redirects to login when not authenticated" do
    get admin_dashboard_url
    assert_redirected_to login_path
  end

  test "redirects to root when authenticated but not admin" do
    sign_in users(:user)
    get admin_dashboard_url
    assert_redirected_to root_path
  end

  test "renders when authenticated as admin" do
    sign_in users(:admin)
    get admin_dashboard_url
    assert_response :success
  end
end
