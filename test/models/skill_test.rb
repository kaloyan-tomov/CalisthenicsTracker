require "test_helper"

class SkillTest < ActiveSupport::TestCase
  test "requires a unique name" do
    Skill.create!(name: "Handstand")
    duplicate = Skill.new(name: "Handstand")
    assert_not duplicate.valid?
  end

  test "rejects names longer than 80 characters" do
    skill = Skill.new(name: "a" * 81)
    assert_not skill.valid?
  end

  test "attempts_count reflects number of posts" do
    skill = skills(:one)
    assert_equal skill.posts.count, skill.attempts_count
  end

  test "weighted_score returns nil when no posts have ratings" do
    skill = Skill.create!(name: "Brand New")
    assert_nil skill.weighted_score
  end

  test "weighted_score averages rated posts" do
    skill = Skill.create!(name: "Test Skill")
    post = Post.create!(user: users(:user), content: "x", skill_ids: [skill.id])
    Rating.create!(user: users(:admin), post: post, score: 5)
    assert_equal 5.0, skill.weighted_score
  end
end
