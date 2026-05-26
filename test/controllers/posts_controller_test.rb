require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "index redirects to login when not authenticated" do
    get posts_url
    assert_redirected_to login_path
  end

  test "index renders when authenticated" do
    sign_in users(:user)
    get posts_url
    assert_response :success
  end

  test "index supports skill filter" do
    sign_in users(:user)
    get posts_url(skill_id: skills(:one).id)
    assert_response :success
  end

  test "create persists a valid post" do
    sign_in users(:user)
    assert_difference("Post.count", 1) do
      post posts_url, params: { post: { content: "Made it!", skill_ids: [skills(:one).id] } }
    end
    assert_redirected_to posts_path
  end

  test "create rejects empty content" do
    sign_in users(:user)
    assert_no_difference("Post.count") do
      post posts_url, params: { post: { content: "", skill_ids: [skills(:one).id] } }
    end
  end

  test "create rejects post with no skills" do
    sign_in users(:user)
    assert_no_difference("Post.count") do
      post posts_url, params: { post: { content: "Hello", skill_ids: [] } }
    end
  end

  test "create blocks timed-out users" do
    user = users(:user)
    user.update!(timeout_until: 1.hour.from_now)
    sign_in user

    assert_no_difference("Post.count") do
      post posts_url, params: { post: { content: "Hi", skill_ids: [skills(:one).id] } }
    end
    assert_redirected_to posts_path
  end

  test "destroy is forbidden for non-owner non-admin" do
    sign_in users(:user)
    other_post = posts(:two)
    assert_no_difference("Post.count") do
      delete post_url(other_post)
    end
  end

  test "destroy works for owner" do
    sign_in users(:user)
    own_post = posts(:one)
    assert_difference("Post.count", -1) do
      delete post_url(own_post)
    end
  end

  test "destroy works for admin on any post" do
    sign_in users(:admin)
    foreign_post = posts(:one)
    assert_difference("Post.count", -1) do
      delete post_url(foreign_post)
    end
  end
end
