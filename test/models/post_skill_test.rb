require "test_helper"

class PostSkillTest < ActiveSupport::TestCase
  test "post can have multiple skills" do
    post = Post.create!(user: users(:user), content: "Multi-skill", skill_ids: [skills(:one).id, skills(:two).id])
    assert_equal 2, post.skills.count
  end

  test "same skill cannot be added to the same post twice" do
    post = Post.create!(user: users(:user), content: "Single", skill_ids: [skills(:one).id])
    duplicate = PostSkill.new(post: post, skill: skills(:one))
    assert_not duplicate.valid?
  end
end
