require "test_helper"

class FriendshipTest < ActiveSupport::TestCase
  test "status must be pending or accepted" do
    f = Friendship.new(requester: users(:user), receiver: users(:admin), status: "rejected")
    assert_not f.valid?
  end

  test "cannot friend yourself" do
    f = Friendship.new(requester: users(:user), receiver: users(:user), status: "pending")
    assert_not f.valid?
    assert_includes f.errors[:receiver_id], "can't be yourself"
  end

  test "cannot send duplicate friend request" do
    Friendship.where(requester: users(:user), receiver: users(:unconfirmed)).destroy_all
    Friendship.create!(requester: users(:user), receiver: users(:unconfirmed), status: "pending")
    dup = Friendship.new(requester: users(:user), receiver: users(:unconfirmed), status: "pending")
    assert_not dup.valid?
  end

  test "accept! sets status to accepted" do
    f = Friendship.create!(requester: users(:user), receiver: users(:unconfirmed), status: "pending")
    f.accept!
    assert_equal "accepted", f.reload.status
  end
end
