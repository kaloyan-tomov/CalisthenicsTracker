require "test_helper"

class FriendshipsControllerTest < ActionDispatch::IntegrationTest
  test "create requires authentication" do
    post friendships_url, params: { receiver_id: users(:admin).id }
    assert_redirected_to login_path
  end

  test "create sends a friend request" do
    sign_in users(:user)
    Friendship.where(requester: users(:user), receiver: users(:unconfirmed)).destroy_all

    assert_difference("Friendship.count", 1) do
      post friendships_url, params: { receiver_id: users(:unconfirmed).id }
    end
  end

  test "create cannot send a request to yourself" do
    sign_in users(:user)
    assert_no_difference("Friendship.count") do
      post friendships_url, params: { receiver_id: users(:user).id }
    end
  end

  test "accept marks friendship as accepted when current_user is receiver" do
    sign_in users(:user)
    f = friendships(:one)
    patch accept_friendship_url(f)
    assert_equal "accepted", f.reload.status
  end

  test "accept is rejected when current_user is not the receiver" do
    sign_in users(:admin)
    f = friendships(:one)
    patch accept_friendship_url(f)
    assert_equal "pending", f.reload.status
  end

  test "decline destroys friendship when current_user is receiver" do
    sign_in users(:user)
    f = friendships(:one)
    assert_difference("Friendship.count", -1) do
      delete decline_friendship_url(f)
    end
  end

  test "friends page renders for authenticated user" do
    sign_in users(:user)
    get friends_url
    assert_response :success
  end

  test "friend_requests page renders for authenticated user" do
    sign_in users(:user)
    get friend_requests_url
    assert_response :success
  end
end
