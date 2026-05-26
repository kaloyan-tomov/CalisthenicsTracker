require "test_helper"

class SkillsControllerTest < ActionDispatch::IntegrationTest
  test "index requires authentication" do
    get skills_url
    assert_redirected_to login_path
  end

  test "show requires authentication" do
    get skill_url(skills(:one))
    assert_redirected_to login_path
  end

  test "index renders for authenticated user" do
    sign_in users(:user)
    get skills_url
    assert_response :success
  end

  test "show renders for authenticated user" do
    sign_in users(:user)
    get skill_url(skills(:one))
    assert_response :success
  end

  test "show supports pagination params" do
    sign_in users(:user)
    get skill_url(skills(:one), page: 2)
    assert_response :success
  end
end
