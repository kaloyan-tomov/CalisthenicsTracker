require "test_helper"

class HomePageControllerTest < ActionDispatch::IntegrationTest
  test "root renders" do
    get root_url
    assert_response :success
  end

  test "login page renders" do
    get login_url
    assert_response :success
  end

  test "register page renders" do
    get "/register"
    assert_response :success
  end

  test "create_user creates a new unconfirmed user" do
    assert_difference("User.count", 1) do
      post "/register", params: {
        user: {
          username: "Brand New",
          email: "brand-new@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    created = User.find_by(email: "brand-new@example.com")
    assert_not created.confirmed?
    assert_redirected_to login_path
  end

  test "create_user rejects mismatched password confirmation" do
    assert_no_difference("User.count") do
      post "/register", params: {
        user: {
          username: "X",
          email: "x@example.com",
          password: "password123",
          password_confirmation: "different"
        }
      }
    end
  end
end
