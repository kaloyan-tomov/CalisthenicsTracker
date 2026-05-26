require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "requires content" do
    post = Post.new(user: users(:user), skill_ids: [skills(:one).id])
    assert_not post.save
    assert_includes post.errors[:content], "can't be blank"
  end

  test "rejects content longer than 1000 characters" do
    post = Post.new(user: users(:user), content: "a" * 1001, skill_ids: [skills(:one).id])
    assert_not post.save
    assert_match(/too long/, post.errors[:content].first)
  end

  test "requires at least one skill" do
    post = Post.new(user: users(:user), content: "Look at this attempt")
    assert_not post.save
    assert_includes post.errors[:skills], "must include at least one skill"
  end

  test "creates valid post" do
    post = Post.new(user: users(:user), content: "Valid content", skill_ids: [skills(:one).id])
    assert post.save
  end

  test "average_rating returns nil when there are no ratings" do
    post = Post.create!(user: users(:user), content: "Fresh", skill_ids: [skills(:one).id])
    assert_nil post.average_rating
  end

  test "average_rating computes mean of all rating scores" do
    post = Post.create!(user: users(:user), content: "Rated", skill_ids: [skills(:one).id])
    Rating.create!(user: users(:admin), post: post, score: 4)
    assert_equal 4.0, post.average_rating
  end

  test "destroying user cascades to posts" do
    user = users(:user)
    assert_difference("Post.count", -user.posts.count) do
      user.destroy
    end
  end
end
