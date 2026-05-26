require "test_helper"

class RatingsControllerTest < ActionDispatch::IntegrationTest
  test "create requires authentication" do
    post post_ratings_url(posts(:one)), params: { rating: { score: 4 } }
    assert_redirected_to login_path
  end

  test "non-admin cannot create rating" do
    sign_in users(:user)
    Rating.where(user: users(:user), post: posts(:one)).destroy_all
    assert_no_difference("Rating.count") do
      post post_ratings_url(posts(:one)), params: { rating: { score: 4 } }
    end
  end

  test "admin can create rating" do
    sign_in users(:admin)
    Rating.where(user: users(:admin), post: posts(:one)).destroy_all
    assert_difference("Rating.count", 1) do
      post post_ratings_url(posts(:one)), params: { rating: { score: 5, comment: "Great" } }
    end
  end

  test "admin re-rating updates existing rating instead of creating new" do
    sign_in users(:admin)
    Rating.where(user: users(:admin), post: posts(:one)).destroy_all
    Rating.create!(user: users(:admin), post: posts(:one), score: 2)

    assert_no_difference("Rating.count") do
      post post_ratings_url(posts(:one)), params: { rating: { score: 5 } }
    end

    assert_equal 5, Rating.find_by(user: users(:admin), post: posts(:one)).score
  end

  test "timed-out admin cannot rate" do
    admin = users(:admin)
    admin.update!(timeout_until: 1.hour.from_now)
    sign_in admin

    Rating.where(user: admin, post: posts(:one)).destroy_all
    assert_no_difference("Rating.count") do
      post post_ratings_url(posts(:one)), params: { rating: { score: 5 } }
    end
  end
end
