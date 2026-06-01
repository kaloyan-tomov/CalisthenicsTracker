require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "requires username" do
    user = User.new(email: "x@example.com", password: "Password123")
    assert_not user.save
    assert_includes user.errors[:username], "can't be blank"
  end

  test "requires unique email" do
    user = User.new(email: users(:user).email, username: "another", password: "Password123")
    assert_not user.save
    assert_includes user.errors[:email], "has already been taken"
  end

  test "requires password of at least 6 characters" do
    user = User.new(email: "new@example.com", username: "new", password: "Ab1")
    assert_not user.save
  end

  test "requires password with uppercase lowercase and number" do
    user = User.new(email: "new@example.com", username: "newuser", password: "password123")
    assert_not user.save
    assert_includes user.errors[:password], "must include at least one uppercase letter, one lowercase letter, and one number (minimum 6 characters)"
  end

  test "creates valid trainee user" do
    user = User.new(email: "valid@example.com", username: "valid", password: "Password123")
    assert user.save
    assert user.trainee?
  end

  test "timed_out? is false when timeout_until is nil" do
    user = users(:user)
    user.update!(timeout_until: nil)
    assert_not user.timed_out?
  end

  test "timed_out? is false when timeout_until is in the past" do
    user = users(:user)
    user.update!(timeout_until: 1.hour.ago)
    assert_not user.timed_out?
  end

  test "timed_out? is true when timeout_until is in the future" do
    user = users(:user)
    user.update!(timeout_until: 1.hour.from_now)
    assert user.timed_out?
  end

  test "role enum exposes admin and trainee predicates" do
    assert users(:admin).admin?
    assert users(:user).trainee?
  end

  test "friends returns accepted friends in both directions" do
    accepted = friendships(:two)
    assert_includes accepted.requester.friends, accepted.receiver
    assert_includes accepted.receiver.friends, accepted.requester
  end

  test "pending invitations are exposed separately" do
    pending = friendships(:one)
    assert_includes pending.requester.pending_sent_invitations, pending
    assert_includes pending.receiver.pending_received_invitations, pending
  end
end
