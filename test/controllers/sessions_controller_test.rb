require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "valid credentials with confirmed user sign in" do
    post user_session_url, params: {
      user: { email: users(:user).email, username: users(:user).username, password: "password123" }
    }
    assert_redirected_to root_path
  end

  test "invalid password redirects back to login" do
    post user_session_url, params: {
      user: { email: users(:user).email, username: users(:user).username, password: "wrong" }
    }
    assert_redirected_to login_path
  end

  test "wrong username does not sign in even with valid email and password" do
    post user_session_url, params: {
      user: { email: users(:user).email, username: "wronguser", password: "password123" }
    }
    assert_redirected_to login_path
  end

  test "unconfirmed user cannot sign in" do
    post user_session_url, params: {
      user: { email: users(:unconfirmed).email, username: users(:unconfirmed).username, password: "password123" }
    }
    assert_redirected_to login_path
  end
end
