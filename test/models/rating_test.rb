require "test_helper"

class RatingTest < ActiveSupport::TestCase
  test "score must be between 1 and 5" do
    [0, 6, -1, 100].each do |bad_score|
      rating = Rating.new(user: users(:admin), post: posts(:one), score: bad_score)
      assert_not rating.valid?, "expected #{bad_score} to be invalid"
    end
  end

  test "score in 1..5 is valid" do
    Rating.where(user: users(:admin), post: posts(:one)).destroy_all
    rating = Rating.new(user: users(:admin), post: posts(:one), score: 3)
    assert rating.valid?
  end

  test "one user can rate the same post only once" do
    Rating.where(user: users(:admin), post: posts(:one)).destroy_all
    Rating.create!(user: users(:admin), post: posts(:one), score: 4)
    duplicate = Rating.new(user: users(:admin), post: posts(:one), score: 5)
    assert_not duplicate.valid?
  end
end
