require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "requires content" do
    comment = Comment.new(user: users(:user), post: posts(:one))
    assert_not comment.save
    assert_includes comment.errors[:content], "can't be blank"
  end

  test "rejects content longer than 1000 characters" do
    comment = Comment.new(user: users(:user), post: posts(:one), content: "a" * 1001)
    assert_not comment.save
  end

  test "creates valid comment" do
    comment = Comment.new(user: users(:user), post: posts(:one), content: "Nice form")
    assert comment.save
  end

  test "destroying post cascades to comments" do
    post = posts(:one)
    post.comments.create!(user: users(:user), content: "delete me")
    assert_difference("Comment.count", -post.comments.count) do
      post.destroy
    end
  end
end
