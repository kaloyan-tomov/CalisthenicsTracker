require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "create requires authentication" do
    post post_comments_url(posts(:one)), params: { comment: { content: "hi" } }
    assert_redirected_to login_path
  end

  test "create persists a valid comment" do
    sign_in users(:user)
    assert_difference("Comment.count", 1) do
      post post_comments_url(posts(:one)), params: { comment: { content: "Great!" } }
    end
    assert_redirected_to post_path(posts(:one))
  end

  test "create rejects empty content" do
    sign_in users(:user)
    assert_no_difference("Comment.count") do
      post post_comments_url(posts(:one)), params: { comment: { content: "" } }
    end
  end

  test "create blocks timed-out users" do
    user = users(:user)
    user.update!(timeout_until: 1.hour.from_now)
    sign_in user

    assert_no_difference("Comment.count") do
      post post_comments_url(posts(:one)), params: { comment: { content: "hi" } }
    end
  end

  test "destroy works for comment owner" do
    sign_in users(:user)
    comment = posts(:one).comments.create!(user: users(:user), content: "mine")
    assert_difference("Comment.count", -1) do
      delete post_comment_url(posts(:one), comment)
    end
  end

  test "destroy is forbidden for non-owner non-admin" do
    sign_in users(:user)
    other_comment = posts(:one).comments.create!(user: users(:admin), content: "admin's")
    assert_no_difference("Comment.count") do
      delete post_comment_url(posts(:one), other_comment)
    end
  end

  test "destroy works for admin on any comment" do
    sign_in users(:admin)
    other_comment = posts(:one).comments.create!(user: users(:user), content: "user's")
    assert_difference("Comment.count", -1) do
      delete post_comment_url(posts(:one), other_comment)
    end
  end
end
